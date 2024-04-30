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
    $db_name = "kodb",

    [bool][Parameter(Mandatory = $false)]
    $quiet = $false
)

. "$PSScriptRoot\logger.ps1"


function GetFileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return 'utf8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        '^efbbbf'   { return 'utf8' }
        '^2b2f76'   { return 'utf7' }
        '^fffe'     { return 'unicode' }
        '^feff'     { return 'bigendianunicode' }
        '^0000feff' { return 'utf32' }
        default     { return 'ascii' }
    }
}

function Main {
  # Check if mssql-scripter command is available
  if (-not (Get-Command mssql-scripter -ErrorAction SilentlyContinue)) {
    MessageError "Error: 'mssql-scripter' command is not available."
    MessageError "Please make sure you have Python installed and then run:"
    MessageError "pip install mssql-scripter"
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
    # TODO: Delete this nasty workaround once sqlfluff implements this: https://github.com/sqlfluff/sqlfluff/issues/5829
    # mssql-scripter or more specifically the sqltoolsservice it uses in the background, generates randomly / sometimes
    # white spaces in the last GO statement of the file. It behaves inconsistenly and hard to reproduce, but when it happens
    # it is annoying as hell since it bloats the diff for no good reason.
    $encoding = GetFileEncoding $fn.FullName
    $content = Get-Content $fn.FullName -Raw
    Set-Content $fn.FullName ($content -replace "\s*[\n\s]GO[\n\s]*$", "`n`nGO") -Encoding $encoding

    $name = $fn.Name.Split(".")[1]
    Move-Item -Path $fn.FullName -Destination "src/procedure/$name.sql" -Force
  }

  Remove-Item tmp -Recurse

  MessageSuccess "Successfully exported [$db_name] database from [$server_name] SQL server."
}

Main
if (-not $quiet) {
  cmd /c 'pause'
}
