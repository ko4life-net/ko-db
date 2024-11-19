# If you invoke the script from the terminal, you can specify the server and db name in case you changed it.
# Otherwise just stick to the default values. example:
# .\import.ps1 -db_name "mydb"
# Additionally in case of issues, you can run the following command as admin to restart the SQL services:
# Get-Service -DisplayName 'SQL Server (*' | ForEach-Object { echo "Restarting $($_.DisplayName)..."; Restart-Service $_.DisplayName }

param (
    # change server_name if you installed your sql server as a Named Instance.
    # If you installed on the Default Instance, then you can leave this as-is.
    [string][Parameter(Mandatory = $false)]
    $server_name = "localhost",

    [string][Parameter(Mandatory = $false)]
    $db_name = "kodb",

    [switch][Parameter(Mandatory = $false)]
    $skip_migration_scripts,

    [switch][Parameter(Mandatory = $false)]
    $skip_odbc_creation,

    # Generate diffs for each migration script that is not archived.
    # Warning: make sure to commit your changes before running the script with this enabled, or you may lose work
    [switch][Parameter(Mandatory = $false)]
    $generate_diffs,

    [switch][Parameter(Mandatory = $false)]
    $quiet
)

. "$PSScriptRoot\utils.ps1"

function ValidateArgs {
  if (-not (ValidateServerNameInput $server_name)) {
    exit_script 1 $quiet
  }

  if ($skip_migration_scripts -and $generate_diffs) {
    MessageError "Error: skip_migration_scripts and generate_diffs args are mutually exclusive."
    exit_script 1 $quiet
  }
}

function ConnectToSqlServer {
  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") > $null
  $server = $null
  try {
    $server = New-Object Microsoft.SqlServer.Management.Smo.Server($server_name)
    $server.ConnectionContext.ConnectTimeout = 5
    $server.ConnectionContext.Connect()
  } catch {
    Write-Error $_
    exit_script 1 $quiet
  }

  return $server
}

# Always mention in your queries which DB you use when invoking this function (example: "USE master; my query...")
function InvokeSqlQuery {
  param ([string][Parameter(Mandatory)] $query)
  Message "Query: [$query]"
  $connection_string = "Server=$server_name;Integrated Security=True;Encrypt=False;TrustServerCertificate=True;"
  return Invoke-Sqlcmd -ConnectionString $connection_string -Query "$query"
}

# Normally your scripts will anyway mention which db they use, hence the target_db argument is optional
function InvokeSqlScript {
  param ([string][Parameter(Mandatory)] $script_path, [string][Parameter(Mandatory=$false)] $target_db = $db_name)
  $connection_string = "Server=$server_name;Database=$target_db;Integrated Security=True;Encrypt=False;TrustServerCertificate=True;"
  return Invoke-Sqlcmd -ConnectionString $connection_string -InputFile "$script_path"
}

function RecreateDb {
  param ([Microsoft.SqlServer.Management.Smo.Server][Parameter(Mandatory)] $server_instance)

  if ($server_instance.Databases[$db_name]) {
    # Create a local backup of the db prefixed with a timestamp, just in case the user forgot to save their work.
    MessageInfo 'Database already exists. Creating backup before recreating it...'
    $bak_file = $PSScriptRoot + "\" + (Get-Date -Format "yyyyMMddTHHmmss") + "_" + $db_name + ".bak"
    Message "Dumping database snapshot to [$bak_file]"
    InvokeSqlScript -script_path "src/misc/backup_db.sql" -target_db "master"
    InvokeSqlQuery -query "USE master; EXEC N3BackupDatabase @DatabaseName = '$db_name', @BackupFilePath = '$bak_file';"

    # Drop the existing database
    InvokeSqlQuery -query "USE master; ALTER DATABASE [$db_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$db_name];"
  }

  MessageInfo "Creating database $db_name..."
  # `Latin1_General_100_CS_AS_SC_UTF8` collation with UTF-8 support requires MSSQL 2019 or later.
  # Details: https://learn.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-ver16#utf8
  #
  # Archived migration scripts may fail from script 0021 due to the migration of `text` to `varchar`.
  # If you want to test scripts with the initial setup, use `SQL_Latin1_General_CP1_CI_AS` collation instead.
  InvokeSqlQuery -query "USE master; CREATE DATABASE [$db_name] COLLATE Latin1_General_100_CS_AS_SC_UTF8;"
}

function RunInitialDbScripts {
  foreach ($dir In $("schema", "procedure", "data")) {
    $scripts = Get-ChildItem "src/$dir" -Filter "*.sql"
    MessageInfo "`n`n### Running $($scripts.Count) $dir scripts... ###"
    foreach ($fn In $scripts) {
      Message $fn.FullName
      InvokeSqlScript -script_path $fn.FullName
    }
  }
}

function GetMigrationScripts {
  return Get-ChildItem "src/migration" -Filter "*.sql" | Sort-Object {[int]($_ -split '_')[0]} | ForEach-Object {$_}
}

function RunMigrationScripts {
  $scripts = GetMigrationScripts
  MessageInfo "`n`n### Running $($scripts.Count) migration scripts... ###"
  foreach ($script In $scripts) {
    Message $script.FullName
    InvokeSqlScript -script_path $script.FullName
  }
}

function RunMigrationScriptsAndGenerateDiffs {
  $scripts = GetMigrationScripts
  MessageInfo "`n`n### Running $($scripts.Count) migration scripts and generate diffs... ###"
  $targetDirs = ".\src\schema\", ".\src\data\", ".\src\procedure\"
  $tempUniqueCommitMessage = "####" + (New-Guid)

  git reset # unstage all changes
  git clean -f .\src\migration\*.diff # cleanup previous untracked diff files
  foreach ($script In $scripts) {
    Message $script.FullName
    InvokeSqlScript -script_path $script.FullName
    .\export.ps1 -server_name $server_name -db_name $db_name -skip_format -quiet
    git add $targetDirs
    $diffOutputFile = $script.FullName + ".diff"
    # Note that powershell messes up with the output and corrupts the patch, hence we use cmd here.
    cmd.exe /c "git diff --staged $targetDirs > $diffOutputFile"
    git commit -m $tempUniqueCommitMessage
  }
  # Note that we're intentionally doing it this way, to be sure that we're not deleting commits we shouldn't
  $commits = @(git rev-list --grep="$tempUniqueCommitMessage" --reverse HEAD)
  if ($commits.Count) {
    git reset --hard "$($commits[0])^1"
  }
}

function CreateDbCredentials {
  MessageInfo "`n`n### Creating login and user for $db_name... ###"
  $login_script_file = "src/misc/create_login.sql"
  Message $login_script_file
  $output_script_file = Join-Path $env:TEMP "create_login_$(New-Guid).sql"
  (Get-Content $login_script_file) -replace "###DB_NAME###", $db_name | Out-File $output_script_file
  InvokeSqlScript -script_path "$output_script_file"
}

function Main {
  if (-not (Get-Module sqlserver -ListAvailable)) {
    MessageInfo "Installing missing 'sqlserver' powershell module..."
    # ensure we first install the NuGet package provider so that Install-Module won't prompt us
    if (-not (Get-PackageProvider -ListAvailable | Where-Object { $_.Name -eq 'NuGet' })) {
      Install-PackageProvider NuGet -Force -Scope CurrentUser
    }
    Install-Module sqlserver -AllowClobber -Force -Scope CurrentUser
  }

  ValidateArgs

  $server = ConnectToSqlServer
  RecreateDb -server_instance $server
  RunInitialDbScripts

  if ($skip_migration_scripts) {
    MessageInfo "Skipping migration scripts..."
  } else {
    if ($generate_diffs) {
      RunMigrationScriptsAndGenerateDiffs
    } else {
      RunMigrationScripts
    }
  }

  CreateDbCredentials

  if (-not $skip_odbc_creation) {
    MessageInfo "Creating odbc configurations..."
    .\odbcad.ps1 -server_name $server_name -quiet
  }

  MessageSuccess "Successfully imported [$db_name] database into [$server_name] SQL server!"
}

Main
exit_script 0 $quiet
