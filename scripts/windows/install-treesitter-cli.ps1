[CmdletBinding()]
Param(
    [switch]$Force
)

if ((-not $Force) -and (Get-Command tree-sitter -ErrorAction SilentlyContinue)) {
    $Version = tree-sitter --version
    Write-Host "tree-sitter already installed: $Version"
    exit 0
}

## Try GitHub release download first
Write-Host "Attempting to install tree-sitter-cli from GitHub releases"

$InstallDir = "$env:LOCALAPPDATA\bin"
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

## Detect architecture
$Arch = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture
switch ($Arch) {
    "X64" { $GitHubArch = "x86_64" }
    "Arm64" { $GitHubArch = "aarch64" }
    default { 
        Write-Warning "Unsupported architecture: $Arch. Will try npm fallback."
        $GitHubArch = ""
    }
}

if ([string]::IsNullOrEmpty($GitHubArch)) {
    Write-Host "Skipping GitHub download, falling back to npm"
} else {
    try {
        $ReleaseUrl = "https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest"
        $ReleaseInfo = Invoke-RestMethod -Uri $ReleaseUrl
        
        $DownloadUrl = $ReleaseInfo.assets | Where-Object { $_.name -match "windows-$GitHubArch\.zip" } | Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
        
        if ($DownloadUrl) {
            Write-Host "Downloading from: $DownloadUrl"
            $TempZip = Join-Path -Path $env:TEMP -ChildPath "tree-sitter.zip"
            $TempDir = Join-Path -Path $env:TEMP -ChildPath "tree-sitter-extract"
            
            Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempZip -ErrorAction Stop
            
            if (Test-Path $TempDir) {
                Remove-Item -Recurse -Force $TempDir
            }
            New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
            
            Expand-Archive -Path $TempZip -DestinationPath $TempDir -Force
            
            $ExePath = Get-ChildItem -Path $TempDir -Filter "tree-sitter.exe" -Recurse | Select-Object -First 1
            
            if ($ExePath) {
                Copy-Item -Path $ExePath.FullName -Destination (Join-Path -Path $InstallDir -ChildPath "tree-sitter.exe") -Force
                
                ## Add to PATH if not already there
                $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
                if ($CurrentPath -notlike "*$InstallDir*") {
                    [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$InstallDir", "User")
                    Write-Host "Added $InstallDir to user PATH"
                }
                
                ## Update session PATH
                $env:PATH = "$env:PATH;$InstallDir"
                
                if (Get-Command tree-sitter -ErrorAction SilentlyContinue) {
                    $Version = tree-sitter --version
                    Write-Host "tree-sitter installed from GitHub: $Version"
                    
                    # Cleanup
                    Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue
                    Remove-Item -Recurse -Path $TempDir -Force -ErrorAction SilentlyContinue
                    exit 0
                }
            }
        } else {
            Write-Host "No matching release found for architecture: $GitHubArch"
        }
    }
    catch {
        Write-Warning "GitHub download failed: $($_.Exception.Message). Falling back to npm"
    }
}

## Fallback to npm install
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "NPM is not installed and GitHub download failed. Please install Node.js/NPM first."
    exit 1
}

Write-Host "Installing tree-sitter-cli with npm"
try {
    npm install -g tree-sitter-cli
}
catch {
    Write-Error "Failed to install tree-sitter-cli. Details: $($_.Exception.Message)"
    exit 1
}

if (Get-Command tree-sitter -ErrorAction SilentlyContinue) {
    $Version = tree-sitter --version
    Write-Host "tree-sitter installed: $Version"
    exit 0
}

Write-Warning "tree-sitter-cli installed but 'tree-sitter' is not in PATH yet."
Write-Host "Open a new terminal and verify with: tree-sitter --version"
exit 1
