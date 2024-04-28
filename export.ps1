# Using this: https://github.com/microsoft/mssql-scripter
# Install python and then: `pip install mssql-scripter`

# If you invoke the script from the terminal, you can specify the server and db name in case you changed it.
# Otherwise just stick to the default values.
param (
    # change server_name if you installed your sql server as a Named Instance.
    # If you installed on the Default Instance, then you can leave this as-is.
    [string][Parameter(Mandatory = $false)]
    $server_name = "localhost",

    [string][Parameter(Mandatory = $false)]
    $db_name = "kodb"
)

. "$PSScriptRoot\logger.ps1"

function Main {
  # Check if mssql-scripter command is available
  if (-not (Get-Command mssql-scripter -ErrorAction SilentlyContinue)) {
    MessageError "Error: 'mssql-scripter' command is not available."  -ForegroundColor Red
    MessageError "Please make sure you have Python installed and then run:"  -ForegroundColor Red
    MessageError "pip install mssql-scripter" -ForegroundColor Red
    exit 1
  }

  mssql-scripter `
    -S $server_name `
    -d $db_name `
    -f $pwd/tmp/schema `
    --file-per-object `
    --exclude-headers `
    --exclude-use-database `
    --display-progress

  mssql-scripter `
    -S $server_name `
    -d $db_name `
    -f $pwd/tmp/data `
    --data-only `
    --file-per-object `
    --exclude-headers `
    --exclude-use-database `
    --display-progress

  # Remove the generated versioned control scripts, so that if some of the migration scripts
  # dropped tables, they will also be removed from the existing version control
  Remove-Item  ".\src\schema\*", ".\src\data\*", ".\src\procedure\*" -Recurse -Force

  foreach ($fn In Get-ChildItem -Path "tmp/data" -Filter "*.Table.sql") {
    $name = $fn.Name.Split(".")[1]
    Move-Item -Path $fn.FullName -Destination "src/data/$name.sql" -Force
  }

  foreach ($fn In Get-ChildItem -Path "tmp/schema" -Filter "*.Table.sql") {
    $name = $fn.Name.Split(".")[1]
    Move-Item -Path $fn.FullName -Destination "src/schema/$name.sql" -Force
  }

  foreach ($fn In Get-ChildItem -Path "tmp/schema" -Filter "*.StoredProcedure.sql") {
    $name = $fn.Name.Split(".")[1]
    Move-Item -Path $fn.FullName -Destination "src/procedure/$name.sql" -Force
  }

  Remove-Item tmp -Recurse

  MessageSuccess "Successfully exported [$db_name] database from [$server_name] SQL server."
}

Main
cmd /c 'pause'
