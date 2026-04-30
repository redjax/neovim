Set-StrictMode -Version 3.0

. (Join-Path $PSScriptRoot 'Common.ps1')

function Invoke-LazySync {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepoRoot,

        [string[]]$ProfileName = @()
    )

    if (-not (Test-CommandAvailable -Name 'nvim')) {
        throw 'Neovim (nvim) is not installed or not in PATH.'
    }

    $configDir = Get-ConfigDirectory -RepoRoot $RepoRoot

    $getLazyProfiles = {
        if (-not (Test-Path -LiteralPath $configDir)) {
            return @()
        }

        $lazyProfiles = New-Object System.Collections.Generic.List[string]
        foreach ($dir in (Get-ChildItem -Path $configDir -Directory)) {
            if (Test-Path -LiteralPath (Join-Path $dir.FullName 'lazy-lock.json')) {
                $lazyProfiles.Add($dir.Name)
            }
        }
        @($lazyProfiles)
    }

    if ($ProfileName.Count -gt 0) {
        $allProfiles = Get-ProfileNames -ConfigDir $configDir
        $profiles = New-Object System.Collections.Generic.List[string]
        foreach ($pn in $ProfileName) {
            if ($allProfiles -contains $pn) {
                $profiles.Add($pn)
            }
            else {
                Write-Warning "Profile '$pn' not found in $configDir, skipping."
            }
        }
    }
    else {
        $profiles = [System.Collections.Generic.List[string]]::new()
        foreach ($p in (& $getLazyProfiles)) { $profiles.Add($p) }
    }

    if ($profiles.Count -eq 0) {
        Write-Host 'No profiles to sync.'
        return
    }

    Write-Host "Using profiles: $($profiles -join ', ')"

    foreach ($profile in $profiles) {
        Write-Host "Processing profile: $profile"
        $env:NVIM_APPNAME = $profile

        nvim --headless "+Lazy! sync" "+Lazy! clean" "+Lazy! update" "+qa"
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to update lockfiles for profile: $profile"
            continue
        }

        Start-Sleep -Seconds 2
    }

    Remove-Item Env:\NVIM_APPNAME -ErrorAction SilentlyContinue
}

function Measure-NvimStartup {
    [CmdletBinding()]
    param(
        [string]$ProfileName = $env:NVIM_APPNAME,
        [string]$LogFile
    )

    if ([string]::IsNullOrWhiteSpace($ProfileName)) {
        $ProfileName = 'nvim'
    }

    if ([string]::IsNullOrWhiteSpace($LogFile)) {
        $LogFile = Join-Path (Get-Location).Path "${ProfileName}_startup.log"
    }

    if (-not (Test-CommandAvailable -Name 'nvim')) {
        throw 'Neovim (nvim) is not installed or not in PATH. Please install Neovim first.'
    }

    Write-Host "Timing startup for profile: $ProfileName (saving log to: $LogFile)"
    nvim --startuptime $LogFile --headless +qall
}
