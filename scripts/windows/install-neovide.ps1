[CmdletBinding()]
param()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Install.ps1')

Install-Neovide
Write-Host 'Installation process complete. You can launch Neovide from the Start Menu.'
