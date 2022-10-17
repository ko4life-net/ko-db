# Using this: https://github.com/microsoft/mssql-scripter
# Install python and then: `pip install mssql-scripter`

# change server_name if you installed your sql server as Named Instance.
# If you installed on the Default Instance, then you can keep it as-is.
$server_name = "localhost"
$db_name = "kodb"

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
