[CmdletBinding()]
param(
    [switch]$Force
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Install.ps1')

Install-TreeSitterCli -Force:$Force
