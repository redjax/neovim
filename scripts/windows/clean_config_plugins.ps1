<#
.SYNOPSIS
  Cleans out Neovim profile plugin directories under $env:LOCALAPPDATA.

.DESCRIPTION
  Usage: .\clean_config_plugins.ps1 [-Profile <profile>|all] [-Yes]
  Profiles are discovered dynamically from the config/ directory in the repo.
  Removes e.g. "$env:LOCALAPPDATA\nvim" or "$env:LOCALAPPDATA\nvim-noplugins".

.PARAMETER Profile
  Profile name to clean, or "all". Default is "nvim".

.PARAMETER Yes
  Skip confirmation prompts.

.EXAMPLE
  .\clean_config_plugins.ps1
  .\clean_config_plugins.ps1 -Profile nvim-noplugins
  .\clean_config_plugins.ps1 -Profile all -Yes
#>

[CmdletBinding()]
param (
  [string]$Profile = "nvim",
  [switch]$Yes,
  [switch]$Help
)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Common.ps1')
. (Join-Path $libDir 'Config.ps1')

$repoRoot = Get-RepoRootFromScript -ScriptPath $scriptPath
$ConfigDir = Get-ConfigDirectory -RepoRoot $repoRoot

$VALID_PROFILES = Get-ProfileNames -ConfigDir $ConfigDir

if ($VALID_PROFILES.Count -eq 0) {
  Write-Error "No profiles found in $ConfigDir"
  exit 1
}

function Show-Usage {
  Write-Host @"
Usage: $($MyInvocation.MyCommand.Name) [-Profile <profile>|all] [-Yes]
Cleans out the Neovim profile plugin directories under `$env:LOCALAPPDATA`.

Profiles are discovered from: $ConfigDir

Options:
  -Profile    Profile name to clean. One of: $($VALID_PROFILES -join ', '), or 'all'. Default: nvim
  -Yes        Don't prompt before deletion.
  -Help       Show this help message.

Examples:
  .\clean_config_plugins.ps1                       # cleans default profile "nvim" -> $env:LOCALAPPDATA\nvim
  .\clean_config_plugins.ps1 -Profile nvim-noplugins  # cleans $env:LOCALAPPDATA\nvim-noplugins
  .\clean_config_plugins.ps1 -Profile all -Yes     # delete all profile dirs without prompt
"@
}

if ($Help) {
  Show-Usage
  exit 0
}

# Build list of directories to delete
$toDelete = @()

if ($Profile -eq "all") {
  foreach ($p in $VALID_PROFILES) {
    $toDelete += Get-ProfileDataCleanupTargets -ProfileName $p -DataRoot $env:LOCALAPPDATA
  }
} else {
  if (-not ($VALID_PROFILES -contains $Profile)) {
    Write-Error "Invalid profile '$Profile'. Valid: $($VALID_PROFILES -join ', '), or all."
    exit 1
  }
  $toDelete += Get-ProfileDataCleanupTargets -ProfileName $Profile -DataRoot $env:LOCALAPPDATA
}

Remove-TargetsWithPrompt -Targets $toDelete -Yes:$Yes

Write-Host "Done. If deletion was successful, open Neovim and run ':Lazy clean' then ':Lazy sync' (or press S when Lazy loads)."
