# Check the .sqlfluff config file for more info
param (
    [switch][Parameter(Mandatory = $false)]
    $verbose_output
)

$dirs_to_format = @(
  "$PSScriptRoot\src\migration\",
  "$PSScriptRoot\src\misc\",
  "$PSScriptRoot\src\procedure\"
)

if ($verbose_output) {
  sqlfluff format -vv $dirs_to_format
} else {
  sqlfluff format $dirs_to_format
}
