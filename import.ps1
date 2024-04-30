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

    # Set this flag to false if you want to skip migration scripts
    [bool][Parameter(Mandatory = $false)]
    $run_migration_scripts = $true,

    # Set this flag to true if you're creating a db release or want to see the current diffs of each migration script
    # Warning: make sure to commit your changes before running the script with this enabled, or you may lose work
    [bool][Parameter(Mandatory = $false)]
    $generate_diffs = $false,

    [bool][Parameter(Mandatory = $false)]
    $quiet = $false
)

. "$PSScriptRoot\logger.ps1"

# Note that the script will fail if you don't have powershell sqlserver module installed.
# To install it, run powershell as admin and execute the following command: `Install-Module sqlserver`
function ConnectToSqlServer {
  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") > $null
  $server = $null
  try {
    $server = New-Object Microsoft.SqlServer.Management.Smo.Server($server_name)
    $server.ConnectionContext.ConnectTimeout = 5
    $server.ConnectionContext.Connect()
  } catch {
    Write-Error $_
    exit 1
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
  InvokeSqlQuery -query "USE master; CREATE DATABASE [$db_name];"
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
    .\export.ps1 -server_name $server_name -db_name $db_name -apply_format $false -quiet $true
    git add $targetDirs
    $diffOutputFile = $script.FullName + ".diff"
    # Note that powershell messes up with the output and corrupts the patch, hence we use cmd here.
    cmd.exe /c "git diff --staged $targetDirs > $diffOutputFile"
    git commit -m $tempUniqueCommitMessage
  }
  # Note that we're intentionally doing it this way, to be sure that we're not deleting commits we shouldn't
  $commits = git rev-list --grep="$tempUniqueCommitMessage" --reverse HEAD
  if ($commits.Count) {
    git reset --hard "$($commits[0])^1"
  }
}

function CreateDbCredentials {
  MessageInfo "`n`n### Creating login and user for $db_name... ###"
  Message "src/misc/create_login.sql"
  InvokeSqlScript -script_path "src/misc/create_login.sql"
}

function Main {
  # Check if the sqlserver module is installed
  if (-not (Get-Module -Name sqlserver -ListAvailable)) {
    MessageError "Error: The 'sqlserver' powershell module is not installed."
    MessageError "Please open PowerShell as Administrator and execute the following command to install it:"
    MessageError "Install-Module -Name sqlserver -Force"
    exit 1
  }

  $server = ConnectToSqlServer
  RecreateDb -server_instance $server
  RunInitialDbScripts

  if ($run_migration_scripts) {
    if ($generate_diffs) {
      RunMigrationScriptsAndGenerateDiffs
    } else {
      RunMigrationScripts
    }
  } else {
    MessageInfo "Skipping migration scripts..."
  }

  CreateDbCredentials
}

Main
if (-not $quiet) {
  cmd /c 'pause'
}
