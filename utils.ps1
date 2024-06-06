# Importable script containing utility helpful functions

function exit_script {
  param (
    [int][Parameter(Mandatory = $false, Position = 0)]
    $code = 0,
    [bool][Parameter(Mandatory = $false, Position = 1)]
    $quiet = $false
  )

  if (-not $quiet) {
    cmd /c 'pause'
  }
  exit $code
}

# MSSQLSERVER instance name indicates it is a Default Instance, which we can connect via localhost or dot,
# any other name indicates it is a Named Instance.
function ValidateServerNameInput {
  param ([string][Parameter(Mandatory, Position = 0)] $server_name)

  $mssql_reg = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server' -ErrorAction Ignore
  if (-not $mssql_reg) {
    MessageError "Error: MSSQL Server is not installed. Please follow the prerequisite section in the readme file."
    return $false
  }

  $sql_instances = @($mssql_reg.InstalledInstances)
  if ($server_name -in "localhost", ".") {
    $server_instance_name = "MSSQLSERVER"
  } else {
    $server_instance_name = $server_name.Split("\")[-1]
  }

  if (-not ($sql_instances -contains $server_instance_name)) {
    MessageError "Error: Invalid sql server name: [$($server_name)]"
    $sql_instances = @($sql_instances | Where-Object { $_ -ne "MSSQLSERVER" })
    if ($sql_instances) {
      MessageError "Available sql named instances: [$($sql_instances -join ', ')]"
      $invoker_script_name = ($MyInvocation.PSCommandPath -split "\\")[-1]
      MessageError "Example: .\$invoker_script_name -server_name "".\$($sql_instances[-1])"""
    }
    return $false
  }

  return $true
}

# Simple and colorful log messages
function Message {
  param ([string][Parameter(Mandatory)] $message)
  Write-Host "$message" -ForegroundColor White
}

function MessageInfo {
  param ([string][Parameter(Mandatory)] $message)
  Write-Host "$message" -ForegroundColor Blue
}

function MessageSuccess {
  param ([string][Parameter(Mandatory)] $message)
  Write-Host "$message" -ForegroundColor Green
}

function MessageWarn {
  param ([string][Parameter(Mandatory)] $message)
  Write-Host "$message" -ForegroundColor Yellow
}

function MessageError {
  param ([string][Parameter(Mandatory)] $message)
  Write-Host "$message" -ForegroundColor Red
}
