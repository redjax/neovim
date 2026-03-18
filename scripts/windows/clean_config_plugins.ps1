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

## Discover valid profiles from config/ directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ConfigDir = Join-Path $RepoRoot "config"

$VALID_PROFILES = @()
if (Test-Path $ConfigDir) {
  $VALID_PROFILES = (Get-ChildItem -Path $ConfigDir -Directory).Name
}

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

function Get-TargetDir($p) {
  return Join-Path $env:LOCALAPPDATA $p
}

# Build list of directories to delete
$toDelete = @()

if ($Profile -eq "all") {
  foreach ($p in $VALID_PROFILES) {
    $toDelete += Get-TargetDir $p
  }
} else {
  if (-not ($VALID_PROFILES -contains $Profile)) {
    Write-Error "Invalid profile '$Profile'. Valid: $($VALID_PROFILES -join ', '), or all."
    exit 1
  }
  $toDelete += Get-TargetDir $Profile
}

foreach ($dir in $toDelete) {
  if (-not (Test-Path -LiteralPath $dir)) {
    Write-Host "Skipping: $dir does not exist."
    continue
  }

  if (-not $Yes) {
    $answer = Read-Host "About to remove '$dir'. Continue? [y/N]"
    if ($answer -notmatch '^[Yy]') {
      Write-Host "Skipped $dir"
      continue
    }
  }

  Write-Host "Removing $dir ..."
  try {
    Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction Stop
    Write-Host "Removed $dir"
  } catch {
    Write-Warning "Failed to remove $($dir): $($_.Exception.Message)"
  }
}

Write-Host "Done. If deletion was successful, open Neovim and run ':Lazy clean' then ':Lazy sync' (or press S when Lazy loads)."
