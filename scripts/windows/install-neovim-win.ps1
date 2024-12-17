Param(
    [switch]$Debug,
    [switch]$DryRun
)

If ( $Debug ) {
    ## enable powershell logging
    $DebugPreference = "Continue"
}

If ( $DryRun ) {
    Write-Host "-DryRun enabled. Actions will be described, instead of taken. Messages will appear in purple where a live action would be taken." -ForegroundColor Magenta
}

$NeovimDependencies = @(
    "win32yank",
    "nodejs-lts",
    "fzf",
    "tree-sitter",
    "ripgrep",
    "FiraCode-NF-Mono",
    "cmake"
)

function Install-ScoopCli {
    Write-Information "Install scoop from https://get.scoop.sh"
    Write-Host "Download & install scoop"

    If ( $DryRun ) {
        Write-Host "[DRY RUN] Would download & install scoop." -ForegroundColor Magenta
        return
    }
    
    If ( -Not (Get-Command scoop) ) {
        try {
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        } catch {
            Write-Error "Failed to install scoop."
            Write-Error "Exception details: $($exc.Message)"
            exit 1
        }
    }
}

function Initialize-ScoopCli {
    Write-Host "Installing aria2 for accelerated downloads"

    If ( $DryRun ) {
        Write-Host "[DRY RUN] Would install aria2." -ForegroundColor Magenta
        Write-Host "[Dry RUN] Would enable scoop 'extras' bucket." -ForegroundColor Magenta
        Write-Host "[Dry RUN] Would disable aria2 warning." -ForegroundColor Magenta
        Write-Host "[Dry RUN] Would install git." -ForegroundColor Magenta

        return
    }

    try {
        scoop install aria2
        if ( -Not $(scoop config aria2-enabled) -eq $True) {
            scoop config aria2-enabled true
        }
    } catch {
        Write-Error "Failed to install aria2."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Enable scoop buckets"
    try {
            scoop bucket add extras
            scoop bucket add nerd-fonts
    } catch {
        Write-Error "Failed to enable 1 or more scoop buckets."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Disable scoop warning when using aria2 for downloads"
    try {
        scoop config aria2-warning-enabled false
    } catch {
        Write-Error "Failed to disable aria2 warning."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Install git"
    try {
        scoop install git
    } catch {
        Write-Error "Failed to install git."
        Write-Error "Exception details: $($exc.Message)"
    }
}

Install-ScoopCli

Initialize-ScoopCli

## Install neovim dependencies with scoop
ForEach ( $app in $NeovimDependencies ) {
    Write-Host "Installing $app"
    try {
        scoop install $app
    } catch {
        Write-Error "Error installing app '$app'. Details: $($_.Exception.message)"
    }
}

If ( -Not (Get-Command nvim) ) {
    ## Install neovim

    Write-Host "Installing neovim"
    try {
        scoop install neovim
    } catch {
        Write-Error "Error installing neovim. Details: $($_.Exception.Message)"
    }
} 