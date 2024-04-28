# If you invoke the script from the terminal, you can specify the server and db name in case you changed it.
# Otherwise just stick to the default values. example:
# .\import.ps1 -db_name "mydb"
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
    $generate_diffs = $false
)

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

function RecreateDb {
  param ([Microsoft.SqlServer.Management.Smo.Server][Parameter(Mandatory)] $server)

  if ($server.Databases[$db_name]) {
    Write-Host 'Database already exists. Will drop and recreate it.'

    # Create a local backup of the db prefixed with a timestamp, just in case the user forgot to save their work.
    $bak_file = $PSScriptRoot + "\" + (Get-Date -Format "yyyyMMddTHHmmss") + "_" + $db_name + ".bak"
    Write-Host "Dumping database snapshot to [$bak_file]"
    $backup_device = New-Object Microsoft.SqlServer.Management.Smo.BackupDeviceItem($bak_file, "File")
    $backup = New-Object Microsoft.SqlServer.Management.Smo.Backup
    $backup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database
    $backup.Database = $db_name
    $backup.Devices.Add($backup_device)
    $backup.SqlBackup($server)

    # Drop existing database
    Invoke-SqlCmd -ServerInstance $server_name -Query `
      " `
        BEGIN `
          ALTER DATABASE [$db_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; `
          DROP DATABASE [$db_name]; `
        END; `
      "
  }

  Write-Host "Creating database $db_name..."
  Invoke-SqlCmd -ServerInstance $server_name -Query "CREATE DATABASE [$db_name];" -Verbose
}

function RunInitialDbScripts {
  foreach ($dir In $("schema", "procedure", "data")) {
    $scripts = Get-ChildItem "src/$dir" -Filter "*.sql"
    Write-Host "`n`n### Running $($scripts.Count) $dir scripts... ###"
    foreach ($fn In $scripts) {
      Write-Host $fn.FullName
      Invoke-Sqlcmd -ServerInstance $server_name -Database $db_name -InputFile $fn.FullName
    }
  }
}

function GetMigrationScripts {
  return Get-ChildItem "src/migration" -Filter "*.sql" | Sort-Object {[int]($_ -split '_')[0]} | ForEach-Object {$_}
}

function RunMigrationScripts {
  $scripts = GetMigrationScripts
  Write-Host "`n`n### Running $($scripts.Count) migration scripts... ###"
  foreach ($script In $scripts) {
    Write-Host $script.FullName
    Invoke-Sqlcmd -ServerInstance $server_name -Database $db_name -InputFile $script.FullName
  }
}

function RunMigrationScriptsAndGenerateDiffs {
  $scripts = GetMigrationScripts
  Write-Host "`n`n### Running $($scripts.Count) migration scripts and generate diffs... ###"
  $targetDirs = ".\src\schema\*", ".\src\data\*", ".\src\procedure\*"
  $tempUniqueCommitMessage = "####" + (uuidgen.exe)

  git reset # unstage all changes
  git clean -f .\src\migration\*.diff # cleanup previous untracked diff files
  foreach ($script In $scripts) {
    Write-Host $script.FullName
    Invoke-Sqlcmd -ServerInstance $server_name -Database $db_name -InputFile $script.FullName
    .\export.ps1
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
  Write-Host "`n`n### Creating login and user for $db_name... ###"
  Write-Host "src/misc/create_login.sql"
  Invoke-Sqlcmd -ServerInstance $server_name -Database $db_name -InputFile "src/misc/create_login.sql"
}

function Main {
  # Check if the sqlserver module is installed
  if (-not (Get-Module -Name sqlserver -ListAvailable)) {
    Write-Host "Error: The 'sqlserver' powershell module is not installed."
    Write-Host "Please open PowerShell as Administrator and execute the following command to install it:"
    Write-Host "Install-Module -Name sqlserver -Force"
    exit 1
  }

  $server = ConnectToSqlServer
  RecreateDb $server
  RunInitialDbScripts

  if ($run_migration_scripts) {
    if ($generate_diffs) {
      RunMigrationScriptsAndGenerateDiffs
    } else {
      RunMigrationScripts
    }
  } else {
    Write-Host "Skipping migration scripts..."
  }

  CreateDbCredentials
}

Main
cmd /c 'pause'
