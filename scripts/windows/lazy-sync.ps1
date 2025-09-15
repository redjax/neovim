<#
.SYNOPSIS
    Synchronize Neovim's Lazy plugin manager plugins.

.DESCRIPTION
    Iterates over predefined list of profiles (or user provided) and updates plugin lockfiles.

    You can run this to update the lazy lockfiles for all your profiles, or the first time after installing the Neovim configs in this repo to initialize your plugins.

.PARAMETER Profile
    Profiles to update. Default is "nvim" and "nvim-work".

.EXAMPLE
    .\update-lazy-lockfiles.ps1
    .\update-lazy-lockfiles.ps1 -Profile nvim-work
    .\update-lazy-lockfiles.ps1 -Profile nvim -Profile nvim-work
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, HelpMessage = "Name of neovim configuration to install from the config/ directory. Can be provided multiple times.")]
    [string[]]$ProfileName = @()
)

function Show-Usage {
    Write-Host "Usage: .\update-lazy-lockfiles.ps1 [-Profile <profile>] [--Help]"
    exit 0
}

## Check if nvim installed
if ( -not ( Get-Command nvim -ErrorAction SilentlyContinue ) ) {
    Write-Error "Neovim (nvim) is not installed or not in PATH."
    exit 1
}

## Default profiles
$defaultProfiles = @("nvim", "nvim-work")

## Use user-provided profiles if given, otherwise defaults
if ( $ProfileName.Count -gt 0 ) {
    $profiles = $ProfileName
} else {
    $profiles = $defaultProfiles
}

Write-Host "Using profiles: $($profiles -join ', ')"

foreach ( $pName in $profiles ) {
    Write-Host "Processing profile: $pName"

    # Set the environment variable for the nvim process in the current session.
    $env:NVIM_APPNAME = $pName

    # Run nvim directly in the current console. Its output will appear here.
    nvim --headless "+Lazy! sync" "+Lazy! clean" "+qa"

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
