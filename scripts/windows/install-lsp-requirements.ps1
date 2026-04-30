[CmdletBinding()]
param()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Install.ps1')

Install-LspRequirements
