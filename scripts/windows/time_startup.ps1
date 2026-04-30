[CmdletBinding()]
Param(
    [string]$ProfileName = $env:NVIM_APPNAME,
    [string]$LogFile = $null
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'NvimOps.ps1')

if ([string]::IsNullOrWhiteSpace($ProfileName)) {
    $ProfileName = 'nvim'
}

if ([string]::IsNullOrWhiteSpace($LogFile)) {
    $LogFile = Join-Path -Path (Get-Location).Path -ChildPath ("{0}_startup.log" -f $ProfileName)
}

try {
    Measure-NvimStartup -ProfileName $ProfileName -LogFile $LogFile
    Write-Host "Startup timing completed. Log saved to $LogFile"
} catch {
    Write-Error "An error occurred while timing Neovim startup: $_"
    exit 1
}