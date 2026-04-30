Set-StrictMode -Version 3.0

function Get-RepoRootFromScript {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptDir = Split-Path -Parent $ScriptPath
    (Resolve-Path (Join-Path $scriptDir '..\..')).Path
}

function Get-ConfigDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RepoRoot
    )

    Join-Path $RepoRoot 'config'
}

function Get-ProfileNames {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ConfigDir
    )

    if (-not (Test-Path -LiteralPath $ConfigDir)) {
        return @()
    }

    (Get-ChildItem -Path $ConfigDir -Directory).Name
}

function Test-CommandAvailable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Write-DryRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-Host "[DRY RUN] $Message" -ForegroundColor Magenta
}

function Add-UserPathEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$PathEntry
    )

    $userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
    if ([string]::IsNullOrWhiteSpace($userPath)) {
        [Environment]::SetEnvironmentVariable('PATH', $PathEntry, 'User')
        $env:PATH = "$PathEntry;$env:PATH"
        return
    }

    $entries = $userPath -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    if ($entries -contains $PathEntry) {
        return
    }

    [Environment]::SetEnvironmentVariable('PATH', "$userPath;$PathEntry", 'User')
    $env:PATH = "$env:PATH;$PathEntry"
}
