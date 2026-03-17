# Build and test Neovim configurations in Docker
# Usage: .\build-and-test.ps1 [config-name] [base-image]

param(
    [switch]$Help,
    [string]$ConfigName = "nvim",
    [string]$BaseImage = "debian:stable-slim"
)

if ($Help) {
    Write-Host "Usage: .\build-and-test.ps1 [-Help] [-ConfigName <name>] [-BaseImage <image>]"
    Write-Host ""
    Write-Host "Build and test Neovim configurations in Docker."
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "  -ConfigName   Neovim config to test (default: nvim)"
    Write-Host "                Options: nvim, nvim-lazyvim, nvim-work, nvim-noplugins, nvim-kickstart"
    Write-Host "  -BaseImage    Docker base image / distro (default: debian:stable-slim)"
    Write-Host "                Examples: debian:stable-slim, ubuntu:24.04, fedora:42, archlinux:base"
    Write-Host "  -Help         Show this help message and exit"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\build-and-test.ps1                                                # Build nvim on debian:stable-slim"
    Write-Host "  .\build-and-test.ps1 -ConfigName nvim-lazyvim                       # Build nvim-lazyvim on debian:stable-slim"
    Write-Host "  .\build-and-test.ps1 -ConfigName nvim -BaseImage ubuntu:24.04       # Build nvim on Ubuntu 24.04"
    Write-Host "  .\build-and-test.ps1 -ConfigName nvim-work -BaseImage fedora:42     # Build nvim-work on Fedora 42"
    exit 0
}

$ErrorActionPreference = "Stop"

# Derive a short tag from the image name (e.g. "debian:stable-slim" -> "debian")
$BaseImageTag = ($BaseImage -split ':')[0]
if ($BaseImageTag -match '/') {
    $BaseImageTag = ($BaseImageTag -split '/')[-1]
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Building Neovim container" -ForegroundColor Cyan
Write-Host "  Config: $ConfigName" -ForegroundColor Cyan
Write-Host "  Distro: $BaseImage" -ForegroundColor Cyan
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
$env:BASE_IMAGE = $BaseImage
$env:BASE_IMAGE_TAG = $BaseImageTag
docker compose build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Build complete: $ConfigName on $BaseImage" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run the container:" -ForegroundColor Yellow
Write-Host "  `$env:CONFIG_NAME='$ConfigName'; `$env:BASE_IMAGE='$BaseImage'; `$env:BASE_IMAGE_TAG='$BaseImageTag'; docker compose run --rm nvim bash" -ForegroundColor White
Write-Host ""
Write-Host "Inside the container, run:" -ForegroundColor Yellow
Write-Host "  nvim              # Start Neovim" -ForegroundColor White
Write-Host "  nvim --version    # Check version" -ForegroundColor White
Write-Host "  :checkhealth      # Run health checks (inside nvim)" -ForegroundColor White
Write-Host ""

Pop-Location
