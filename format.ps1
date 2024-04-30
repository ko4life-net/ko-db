# Check the .sqlfluff config file for more info

sqlfluff format `
  "$PSScriptRoot\src\migration\" `
  "$PSScriptRoot\src\misc\" `
  "$PSScriptRoot\src\procedure\"
