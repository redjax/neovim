<#
.SYNOPSIS
    Updates Neovim plugin lockfiles.

.DESCRIPTION
    Iterates over predefined list of profiles (or user provided) and updates plugin lockfiles.

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
    [string[]]$Profile = @(),
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
if ( $Profile.Count -gt 0 ) {
    $profiles = $Profile
} else {
    $profiles = $defaultProfiles
}

Write-Host "Using profiles: $($profiles -join ', ')"

foreach ( $profile in $profiles ) {
    Write-Host "Processing profile: $profile"

    ## Set environment variable for this iteration
    $env:NVIM_APPNAME = $profile

    ## Run lazy sync and clean
    $proc = Start-Process -FilePath "nvim" -ArgumentList "--headless", "'+Lazy! sync'", "'+Lazy! clean'", "+qa" -NoNewWindow -Wait -PassThru

    if ( $proc.ExitCode -ne 0 ) {
        Write-Warning "Failed to update lockfiles for profile: $profile"
        continue
    }

    Start-Sleep -Seconds 2
}

## Remove environment variable
Remove-Item Env:\NVIM_APPNAME

Write-Host "Updated lockfiles for $($profiles.Count) profile(s)."
