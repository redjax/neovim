# Requires -Version 5.1

## Set install paths
$installDir = "$env:LOCALAPPDATA\Programs\Neovide"
$desktopDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
$desktopFile = Join-Path $desktopDir "Neovide.lnk"

## GitHub API URL for latest Neovide release
$apiUrl = "https://api.github.com/repos/neovide/neovide/releases/latest"

function Download-File($url, $outPath) {
    Write-Host "Downloading $url ..."
    Invoke-WebRequest -Uri $url -OutFile $outPath
}

## Get latest release JSON from GitHub
$response = Invoke-RestMethod -Uri $apiUrl -Headers @{"User-Agent"="PowerShell"}

## Find MSI and EXE assets URLs
$msiAsset = $response.assets | Where-Object { $_.name -like "*.msi" } | Select-Object -First 1
$exeZipAsset = $response.assets | Where-Object { $_.name -like "*.exe.zip" } | Select-Object -First 1

Write-Host "Latest version: $($response.tag_name)"
Write-Host "Found MSI: $($msiAsset.name)"
Write-Host "Found EXE zip: $($exeZipAsset.name)"

## Paths to temporary downloads
$tempMsiPath = Join-Path $env:TEMP $msiAsset.name
$tempZipPath = Join-Path $env:TEMP $exeZipAsset.name

## Download MSI
Download-File $msiAsset.browser_download_url $tempMsiPath

## Run MSI installer - this will prompt for UAC authorization from the user
Write-Host "Launching MSI installer with elevated privileges (UAC prompt expected)..."
$msiProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$tempMsiPath`" /quiet /norestart" -Wait -PassThru -ErrorAction SilentlyContinue

## Check if process is successful
if ($msiProcess.ExitCode -ne 0) {
    Write-Warning "MSI installation failed or was cancelled with exit code $($msiProcess.ExitCode). Falling back to portable EXE..."

    ## Download EXE zip
    Download-File $exeZipAsset.browser_download_url $tempZipPath

    ## Extract EXE zip
    if (-Not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir | Out-Null
    }

    Write-Host "Extracting portable EXE Zip to $installDir..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [IO.Compression.ZipFile]::ExtractToDirectory($tempZipPath, $installDir, $true)

    ## Create shortcut on Start Menu
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($desktopFile)
    $shortcut.TargetPath = Join-Path $installDir "Neovide.exe"
    $shortcut.WorkingDirectory = $installDir
    $shortcut.WindowStyle = 1
    $shortcut.IconLocation = Join-Path $installDir "Neovide.exe"
    $shortcut.Save()

    Write-Host "Neovide portable installed to $installDir."
    Write-Host "Shortcut created at Start Menu."
} else {
    Write-Host "MSI installation succeeded. Neovide should be installed system-wide or per-user now."
}

Write-Host "Installation process complete. You can launch Neovide from the Start Menu."
