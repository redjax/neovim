<#
.SYNOPSIS
    Synchronize Neovim's Lazy plugin manager plugins.

.DESCRIPTION
    Discovers all profiles in config/ that have a lazy-lock.json (i.e. use lazy.nvim)
    and updates their plugin lockfiles. You can override with -ProfileName.

    You can run this to update the lazy lockfiles for all your profiles, or the first time after installing the Neovim configs in this repo to initialize your plugins.

.PARAMETER ProfileName
    Profiles to update. By default, discovers all lazy.nvim profiles from config/.

.EXAMPLE
    .\lazy-sync.ps1
    .\lazy-sync.ps1 -ProfileName nvim-work
    .\lazy-sync.ps1 -ProfileName nvim, nvim-noplugins
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, HelpMessage = "Name of neovim configuration to install from the config/ directory. Can be provided multiple times.")]
    [string[]]$ProfileName = @()
)

function Show-Usage {
    Write-Host "Usage: .\lazy-sync.ps1 [-ProfileName <profile>] [--Help]"
    Write-Host ""
    Write-Host "Without -ProfileName, syncs all profiles that have a lazy-lock.json in config/."
    exit 0
}

## Check if nvim installed
if ( -not ( Get-Command nvim -ErrorAction SilentlyContinue ) ) {
    Write-Error "Neovim (nvim) is not installed or not in PATH."
    exit 1
}

## Discover repo root from script location
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$ConfigDir = Join-Path $RepoRoot "config"

## Discover profiles that use lazy.nvim (have a lazy-lock.json)
function Get-LazyProfiles {
    $lazyProfiles = @()
    if (Test-Path $ConfigDir) {
        foreach ($dir in (Get-ChildItem -Path $ConfigDir -Directory)) {
            if (Test-Path (Join-Path $dir.FullName "lazy-lock.json")) {
                $lazyProfiles += $dir.Name
            }
        }
    }
    return $lazyProfiles
}

## Discover all valid profiles (for validation)
function Get-AllProfiles {
    if (Test-Path $ConfigDir) {
        return (Get-ChildItem -Path $ConfigDir -Directory).Name
    }
    return @()
}

## Use user-provided profiles if given, otherwise discover lazy profiles
if ( $ProfileName.Count -gt 0 ) {
    $allProfiles = Get-AllProfiles
    $profiles = @()
    foreach ($pn in $ProfileName) {
        if ($allProfiles -contains $pn) {
            $profiles += $pn
        } else {
            Write-Warning "Profile '$pn' not found in $ConfigDir, skipping."
        }
    }
} else {
    $profiles = Get-LazyProfiles
}

if ($profiles.Count -eq 0) {
    Write-Host "No profiles to sync."
    exit 0
}

Write-Host "Using profiles: $($profiles -join ', ')"

foreach ( $pName in $profiles ) {
    Write-Host "Processing profile: $pName"

    # Set the environment variable for the nvim process in the current session.
    $env:NVIM_APPNAME = $pName

    # Run nvim directly in the current console. Its output will appear here.
    nvim --headless "+Lazy! sync" "+Lazy! clean" "+Lazy! update" "+qa"

    # Check the exit code of the last command.
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to update lockfiles for profile: $pName"
        continue
    }

    Start-Sleep -Seconds 2
}

## Remove environment variable
Remove-Item Env:\NVIM_APPNAME

Write-Host "Updated lockfiles for $($profiles.Count) profile(s)."
