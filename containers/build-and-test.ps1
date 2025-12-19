# Build and test Neovim configurations in Docker
# Usage: .\build-and-test.ps1 [config-name]

param(
    [string]$ConfigName = "nvim"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Building Neovim container for: $ConfigName" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Push-Location $ScriptDir

# Check if config exists
$ConfigPath = Join-Path $RepoRoot "config\$ConfigName"
if (-not (Test-Path $ConfigPath)) {
    Write-Host "Error: Config '$ConfigName' not found in $RepoRoot\config\" -ForegroundColor Red
    Write-Host ""
    Write-Host "Available configs:" -ForegroundColor Yellow
    Get-ChildItem -Path (Join-Path $RepoRoot "config") -Directory | Where-Object { $_.Name -like "nvim*" } | ForEach-Object { Write-Host "  $($_.Name)" }
    Pop-Location
    exit 1
}

# Build the container
Write-Host ""
Write-Host "Building container..." -ForegroundColor Green

$env:CONFIG_NAME = $ConfigName
docker compose build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Build complete for: $ConfigName" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run the container:" -ForegroundColor Yellow
Write-Host "  `$env:CONFIG_NAME='$ConfigName'; docker compose run --rm nvim" -ForegroundColor White
Write-Host ""
Write-Host "Or directly:" -ForegroundColor Yellow
Write-Host "  docker compose run --rm nvim" -ForegroundColor White
Write-Host ""
Write-Host "Inside the container, run:" -ForegroundColor Yellow
Write-Host "  nvim              # Start Neovim" -ForegroundColor White
Write-Host "  nvim --version    # Check version" -ForegroundColor White
Write-Host "  :checkhealth      # Run health checks (inside nvim)" -ForegroundColor White
Write-Host ""

Pop-Location
