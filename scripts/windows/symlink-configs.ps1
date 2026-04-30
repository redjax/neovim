[CmdletBinding()]
param(
    [switch]$DryRun
)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Common.ps1')
. (Join-Path $libDir 'Config.ps1')

$repoRoot = Get-RepoRootFromScript -ScriptPath $scriptPath
Sync-NvimConfigLinks -RepoRoot $repoRoot -DestinationRoot $env:LOCALAPPDATA -DryRun:$DryRun

Write-Host 'Finished creating links for Neovim configurations.' -ForegroundColor Green
