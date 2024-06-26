# If you invoke the script from the terminal, you can specify the server and db name in case you changed it.
# Otherwise just stick to the default values.
param (
    # change server_name if you installed your sql server as a Named Instance.
    # If you installed on the Default Instance, then you can leave this as-is.
    [string][Parameter(Mandatory = $false)]
    $server_name = "localhost",

    [string][Parameter(Mandatory = $false)]
    $db_name = "kodb",

    # 64 or 32
    [string][Parameter(Mandatory = $false)]
    $platform = "32",

    # When testing connection, we can decide whether to use the Odbc or SqlClient module
    [switch][Parameter(Mandatory = $false)]
    $test_odbc_module,

    [switch][Parameter(Mandatory = $false)]
    $quiet
)

. "$PSScriptRoot\utils.ps1"

function ValidateArgs {
  if ($platform -ne "32" -and $platform -ne "64") {
    MessageError "Wrong platform argument [$platform]. Choose either 64 or 32."
    exit_script 1 $quiet
  }

  if (-not (ValidateServerNameInput $server_name)) {
    exit_script 1 $quiet
  }
}



function SelectSqlDriver {
  $drivers = Get-OdbcDriver | Where-Object { $_.Name -like "*SQL Server*" -and $_.Platform -eq "$platform-bit" }
  if (-not $drivers) {
    MessageWarn "Are you sure SQL Server is installed? I couldn't find any drivers."
    exit_script 1 $quiet
  }

  $selected_driver = $null

  # In quiet mode we'll just return the last driver, assuming it is the most up to date one
  if ($quiet) {
    $selected_driver = $drivers[-1]
    MessageInfo "Selected SQL Driver: {$($selected_driver.Name)}"
    return $selected_driver
  }

  if ($drivers.Count -eq 1) {
    # Select the first one if we only have one driver
    $selected_driver = $drivers[0]
  } else {
    while (-not $selected_driver) {
      MessageInfo "Enter a number to select your SQL Driver:"
      for ($i = 0; $i -lt $drivers.Count; $i++) {
        Message "$($i+1). $($drivers[$i].Name)"
      }

      $user_input = -1
      $input_valid = [int]::TryParse((Read-Host "Input"), [ref]$user_input)
      if (-not $input_valid -or $user_input -lt 1 -or $user_input -gt $drivers.Count) {
        MessageWarn "Invalid selection."
      } else {
        $selected_driver = $drivers[$user_input - 1]
        MessageInfo "Selected SQL Driver: {$($selected_driver.Name)}"
        break
      }
    }
  }

  return $selected_driver
}

function CreateOdbcConnection {
  param ([string][Parameter(Mandatory)] $driver_name)
  Remove-OdbcDsn -Name $db_name -DsnType "User" -ErrorAction Ignore
  Add-OdbcDsn `
    -Name $db_name `
    -DriverName $driver_name `
    -DsnType "User" `
    -SetPropertyValue @(
      "Server=$server_name",
      "Database=$db_name",
      "AutoTranslate=No",
      "Trusted_Connection=Yes"
    )
}

# Refs:
# https://learn.microsoft.com/en-us/dotnet/api/system.data.odbc.odbcconnection.connectionstring
# https://learn.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring
# https://github.com/microsoft/referencesource/blob/master/System.Data/System/Data/Odbc/OdbcConnection.cs
# https://github.com/microsoft/referencesource/blob/master/System.Data/System/Data/SqlClient/SqlConnection.cs
function TestOdbcConnection {
  param ([string][Parameter(Mandatory)] $driver_name)
  $result = $false

  $con_timeout_seconds = 15
  # Note that in later sql servers `Trusted_Connection` replaced `Integrated Security` and changed it to a synonym. Therefore for backwards
  # compatibility we're using `Integrated Security` instead.
  $con_str = "Server={0};UID={1};PWD={1};Timeout={2};Integrated Security=True" -f $server_name, ($db_name + "_user"), $con_timeout_seconds
  $con = $null
  $module = ""
  if ($test_odbc_module) {
    $module = "Odbc"
    $con_str += ";DSN=$db_name;Driver={$driver_name}"
    $con = New-Object System.Data.Odbc.OdbcConnection($con_str)
  } else {
    $module = "SqlClient"
    $con_str += ";Database=$db_name;Encrypt=False;TrustServerCertificate=True"
    $con = New-Object System.Data.SqlClient.SqlConnection($con_str)
  }

  MessageInfo "Testing connection string with $module module: [$($con.ConnectionString)]"
  try {
    $con.Open()
    $result = $con.State -eq [System.Data.ConnectionState]::Open
  } catch {
    MessageError "An error occurred while testing the connection: $_"
  } finally {
    if ($con.State -ne [System.Data.ConnectionState]::Closed) {
      $con.Close()
    }
  }

  return $result
}

function Main {
  ValidateArgs

  $selected_driver = SelectSqlDriver
  CreateOdbcConnection -driver_name $selected_driver.Name
  $is_successful = TestOdbcConnection -driver_name $selected_driver.Name
  if ($is_successful) {
    MessageSuccess "Successfully created odbc connection driver and tested connection!"
  } else {
    MessageError "Failed to test connection. Check that you first imported the database."
    MessageError "If that didn't work, depending on how you installed MSSQL (Default or Named Instance), you may need to change the server above from localhost to yours."
    exit_script 1 $quiet
  }
}

Main
exit_script 0 $quiet
