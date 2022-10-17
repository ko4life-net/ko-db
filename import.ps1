# Note that the script will fail if you don't have powershell sqlserver module installed.
# To install it, run powershell as admin and execute the following command: `Install-Module sqlserver`
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')

# change server_name if you installed your sql server as Named Instance.
# If you installed on the Default Instance, then you can keep it as-is.
$server_name = "localhost"
$db_name = "kodb"

$server = New-Object Microsoft.SqlServer.Management.Smo.Server($server_name)
if (!$server) {
  throw "Failed to connect to mssql local host server."
  exit 1
}

if ($server.Databases[$db_name]) {
  Write-Host 'Database already exists. Will drop and recreate it.'
  Invoke-SqlCmd -ServerInstance $server_name -Query `
    " `
      BEGIN `
        ALTER DATABASE [$db_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; `
        DROP DATABASE [$db_name]; `
        CREATE DATABASE[$db_name]; `
      END; `
    "
} else {
  Write-Host "Creating database $db_name..."
  Invoke-SqlCmd -ServerInstance $server_name -Query "CREATE DATABASE [$db_name];" -Verbose
}

foreach ($dir In $("schema", "procedure", "data", "migration")) {
  $scripts = Get-ChildItem -Path src/$dir -Filter "*.sql"
  Write-Host "`n`n### Running $($scripts.Count) $dir scripts... ###"
  foreach ($fn In $scripts) {
    Write-Host $fn.FullName
    Invoke-Sqlcmd -ServerInstance $server_name -Database $db_name -InputFile $fn.FullName
  }
}

Write-Host "`n`n### Creating login and user for $db_name... ###"
Write-Host "src/misc/create_login.sql"
Invoke-Sqlcmd -ServerInstance $server_name -Database $db_name -InputFile "src/misc/create_login.sql"

cmd /c 'pause'
