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
