<#
.SYNOPSIS
  Cleans out Neovim profile plugin directories under $env:LOCALAPPDATA.

.DESCRIPTION
  Usage: .\clean_config_plugins.ps1 [-Profile <profile>|all] [-Yes]
  Valid profiles: nvim, nvim-work, nvim-lite. Default is "nvim".
  Removes e.g. "$env:LOCALAPPDATA\nvim" or "$env:LOCALAPPDATA\nvim-nvim-lite".

.PARAMETER Profile
  Profile name to clean. One of: nvim, nvim-work, nvim-lite, or "all".

.PARAMETER Yes
  Skip confirmation prompts.

.EXAMPLE
  .\clean_config_plugins.ps1
  .\clean_config_plugins.ps1 -Profile nvim-lite
  .\clean_config_plugins.ps1 -Profile all -Yes
#>

[CmdletBinding()]
param (
  [string]$Profile = "nvim",
  [switch]$Yes,
  [switch]$Help
)

$VALID_PROFILES = @("nvim", "nvim-work", "nvim-lite")

function Show-Usage {
  Write-Host @"
Usage: $($MyInvocation.MyCommand.Name) [-Profile <profile>|all] [-Yes]
Cleans out the Neovim profile plugin directories under `$env:LOCALAPPDATA`.

Options:
  -Profile    Profile name to clean. One of: $($VALID_PROFILES -join ', '), or 'all'. Default: nvim
  -Yes        Don't prompt before deletion.
  -Help       Show this help message.

Examples:
  .\clean_config_plugins.ps1                    # cleans default profile "nvim" -> $env:LOCALAPPDATA\nvim
  .\clean_config_plugins.ps1 -Profile nvim-lite  # cleans $env:LOCALAPPDATA\nvim-nvim-lite
  .\clean_config_plugins.ps1 -Profile all -Yes   # delete all profile dirs without prompt
"@
}

if ($Help) {
  Show-Usage
  exit 0
}

function Get-TargetDir($p) {
  if ($p -eq "nvim") {
    return Join-Path $env:LOCALAPPDATA "nvim"
  } else {
    return Join-Path $env:LOCALAPPDATA "nvim-$p"
  }
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
    Write-Warning "Failed to remove $dir: $($_.Exception.Message)"
  }
}

Write-Host "Done. If deletion was successful, open Neovim and run ':Lazy clean' then ':Lazy sync' (or press S when Lazy loads)."
