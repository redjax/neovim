Set-StrictMode -Version 3.0

. (Join-Path $PSScriptRoot 'Common.ps1')

function Get-NvimRepoConfigPaths {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ConfigDir
    )

    if (-not (Test-Path -LiteralPath $ConfigDir)) {
        Write-Warning "Could not find config path: $ConfigDir"
        return @()
    }

    (Get-ChildItem -Path $ConfigDir -Directory | Select-Object -ExpandProperty FullName)
}

function New-NvimConfigLink {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepoConfigPath,

        [Parameter(Mandatory)]
        [string]$DestinationRoot,

        [switch]$DryRun
    )

    $configName = Split-Path -Leaf $RepoConfigPath
    $destinationPath = Join-Path $DestinationRoot $configName

    if ($DryRun) {
        Write-DryRun "Would link '$RepoConfigPath' -> '$destinationPath'"
        return
    }

    if (Test-Path -LiteralPath $destinationPath) {
        $item = Get-Item -LiteralPath $destinationPath

        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Host "Path is already a link/junction: $destinationPath"
            return
        }

        $backupPath = "$destinationPath.bak"
        if (Test-Path -LiteralPath $backupPath) {
            Write-Warning "$backupPath already exists. Overwriting backup."
            Remove-Item -LiteralPath $backupPath -Recurse -Force
        }

        Write-Warning "Path already exists: $destinationPath. Moving to backup at $backupPath"
        Move-Item -LiteralPath $destinationPath -Destination $backupPath
    }

    Write-Host "Creating link: $RepoConfigPath -> $destinationPath"

    try {
        New-Item -Path $destinationPath -ItemType SymbolicLink -Target $RepoConfigPath -ErrorAction Stop | Out-Null
        return
    }
    catch {
        Write-Warning "Creating symbolic link failed. Falling back to junction. Details: $($_.Exception.Message)"
    }

    New-Item -Path $destinationPath -ItemType Junction -Target $RepoConfigPath -ErrorAction Stop | Out-Null
}

function Sync-NvimConfigLinks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepoRoot,

        [Parameter()]
        [string]$DestinationRoot = $env:LOCALAPPDATA,

        [switch]$DryRun
    )

    $configDir = Get-ConfigDirectory -RepoRoot $RepoRoot
    $configs = Get-NvimRepoConfigPaths -ConfigDir $configDir

    if ($configs.Count -eq 0) {
        throw "No Neovim configurations found in '$configDir'."
    }

    Write-Host "Found [$($configs.Count)] configurations:"
    foreach ($c in $configs) {
        Write-Host "  - $(Split-Path -Leaf $c)"
    }

    foreach ($configPath in $configs) {
        New-NvimConfigLink -RepoConfigPath $configPath -DestinationRoot $DestinationRoot -DryRun:$DryRun
    }
}

function Get-ProfileDataCleanupTargets {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProfileName,

        [Parameter()]
        [string]$DataRoot = $env:LOCALAPPDATA
    )

    $profileRoot = Join-Path $DataRoot $ProfileName
    $targets = @($profileRoot)

    if ($ProfileName -eq 'nvim12') {
        $targets += (Join-Path $profileRoot 'vim.pack')
    }

    $targets
}

function Remove-TargetsWithPrompt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$Targets,

        [switch]$Yes
    )

    foreach ($target in $Targets) {
        if (-not (Test-Path -LiteralPath $target)) {
            Write-Host "Skipping: $target does not exist."
            continue
        }

        if (-not $Yes) {
            $answer = Read-Host "About to remove '$target'. Continue? [y/N]"
            if ($answer -notmatch '^[Yy]') {
                Write-Host "Skipped $target"
                continue
            }
        }

        Write-Host "Removing $target ..."
        try {
            Remove-Item -LiteralPath $target -Recurse -Force -ErrorAction Stop
            Write-Host "Removed $target"
        }
        catch {
            Write-Warning "Failed to remove $($target): $($_.Exception.Message)"
        }
    }
}
