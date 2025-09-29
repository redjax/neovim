[CmdletBinding()]
Param(
    [string]$ProfileName = $env:NVIM_APPNAME,
    [string]$LogFile = (Join-Path -Path (Get-Location).Path -ChildPath "$($ProfileName)_startup.log")
)

if ( -not ( $ProfileName ) ) {
    $ProfileName = "nvim"
}

if ( -not ( $LogFile ) ) {
    $LogFile = (Join-Path -Path (Get-Location).Path -ChildPath "$($ProfileName)_startup.log")
}

if ( -not ( Get-Command nvim -ErrorAction SilentlyContinue ) ) {
    Write-Error "Neovim (nvim) is not installed or not in PATH. Please install Neovim to use this script."
    exit 1
}

Write-Host "Timing startup for profile: $ProfileName (saving log to file: $LogFile)"

try {
    nvim --startuptime $LogFile --headless +qall
    Write-Host "Startup timing completed. Log saved to $LogFile"
} catch {
    Write-Error "An error occurred while timing Neovim startup: $_"
    exit 1
}