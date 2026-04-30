[CmdletBinding()]
param(
    [switch]$DryRun
)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Common.ps1')
. (Join-Path $libDir 'Install.ps1')
. (Join-Path $libDir 'Config.ps1')

$repoRoot = Get-RepoRootFromScript -ScriptPath $scriptPath

if ($DryRun) {
    Write-Host '-DryRun enabled. Actions will be described instead of executed.' -ForegroundColor Magenta
}

Install-NeovimWindowsDependencies -DryRun:$DryRun
Sync-NvimConfigLinks -RepoRoot $repoRoot -DestinationRoot $env:LOCALAPPDATA -DryRun:$DryRun

Write-Host @"
Neovim installation flow completed.

Configurations were linked under: $env:LOCALAPPDATA

To launch Neovim with a specific configuration in PowerShell:

    `$env:NVIM_APPNAME = 'nvim-noplugins'
    nvim
"@

# try {
#     New-NvimConfigSymlink
# }
# catch {
#     Write-Error "Error installing neovim configuration to path '$($NVIM_CONFIG_DIR)'."
#     exit 1
# }
