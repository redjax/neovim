Param(
    [switch]$Debug,
    [switch]$DryRun
)

## Set path script was launched from as a variable
#  Use Set-Location to change to other paths, then
#  Set-Location $CWD to return to the originating path.
$CWD = $PWD.Path

## Path to neovim configuration
$NVIM_CONFIG_SRC = "$($CWD)\config\nvim"

## Path where neovim configuration will be symlinked to
# $NVIM_CONFIG_DIR = "$($env:USERPROFILE)\.config\nvim"
$NVIM_CONFIG_DIR = "$($env:LOCALAPPDATA)\nvim"

If ( $Debug ) {
    ## enable powershell logging
    $DebugPreference = "Continue"
}

If ( $DryRun ) {
    Write-Host "-DryRun enabled. Actions will be described, instead of taken. Messages will appear in purple where a live action would be taken." -ForegroundColor Magenta
}

Write-Debug "CWD: $($CWD)"

## Packages to install with scoop that are required for neovim
$NeovimDependencies = @(
    "win32yank",
    "nodejs-lts",
    "fzf",
    "tree-sitter",
    "ripgrep",
    "FiraCode-NF-Mono",
    "cmake"
    "gcc"
    "lua"
    "luarocks",
    "python",
    "curl",
    "unzip"
)

function Test-IsAdmin {
    ## Check if the current process is running with elevated privileges (admin rights)
    $isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    return $isAdmin
}

function Run-AsAdmin {
    param (
        [string]$Command
    )

    # Check if the script is running as admin
    $isAdmin = [bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        # Prompt to run as administrator if not already running as admin
        $arguments = "-Command `"& {$command}`""
        Write-Debug "Running command: Start-Process powershell -ArgumentList $($arguments) -Verb RunAs"

        try {
            Start-Process powershell -ArgumentList $arguments -Verb RunAs
            return $true  # Indicate that the script was elevated and the command will run
        }
        catch {
            Write-Error "Error executing command as admin. Details: $($_.Exception.Message)"
        }
    }
    else {
        # If already running as admin, execute the command
        Invoke-Expression $command
        return $false  # Indicate that the command was run without elevation
    }
}

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
        }
        catch {
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
    }
    catch {
        Write-Error "Failed to install aria2."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Enable scoop buckets"
    try {
        scoop bucket add extras
        scoop bucket add nerd-fonts
    }
    catch {
        Write-Error "Failed to enable 1 or more scoop buckets."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Disable scoop warning when using aria2 for downloads"
    try {
        scoop config aria2-warning-enabled false
    }
    catch {
        Write-Error "Failed to disable aria2 warning."
        Write-Error "Exception details: $($exc.Message)"
    }

    Write-Host "Install git"
    try {
        scoop install git
    }
    catch {
        Write-Error "Failed to install git."
        Write-Error "Exception details: $($exc.Message)"
    }
}

function Install-Dependencies {
    Install-ScoopCli
    Initialize-ScoopCli

    ## Install neovim dependencies with scoop
    ForEach ( $app in $NeovimDependencies ) {
        If ( $DryRun ) {
            Write-Host "[DRY RUN] Would install app: $app." -ForegroundColor Magenta
        }
        else {
            Write-Host "Installing $app"
            try {
                scoop install $app
            }
            catch {
                Write-Error "Error installing app '$app'. Details: $($_.Exception.message)"
            }
        }
    }

    If ( -Not (Get-Command nvim) ) {
        ## Install neovim

        If ( $DryRun ) {
            Write-Host "[DRY RUN] Would install neovim." -ForegroundColor Magenta
        }
        else {
            Write-Host "Installing neovim"
            try {
                scoop install neovim
            }
            catch {
                Write-Error "Error installing neovim. Details: $($_.Exception.Message)"
            }
        }
    } 
}

function New-NvimConfigSymlink {
    If ( $DryRun ) {
        Write-Host "[DRY RUN] Would create symlink from $NVIM_CONFIG_SRC to $NVIM_CONFIG_DIR." -ForegroundColor Magenta
        return
    }
    else {
        ## Check if config path already exists
        If ( Test-Path $NVIM_CONFIG_DIR ) {
            ## Check if path is directory or junction
            $Item = Get-Item $NVIM_CONFIG_DIR

            ## Check if path is a junction
            If ( $Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint ) {
                Write-Host "Path is already a junction: $($NVIM_CONFIG_DIR)"
                return
            }

            ## Path is a regular directory
            Write-Warning "Path already exists: $NVIM_CONFIG_DIR. Moving to $NVIM_CONFIG_DIR.bak"
            If ( Test-Path "$NVIM_CONFIG_DIR.bak" ) { 
                Write-Warning "$NVIM_CONFIG_DIR.bak already exists. Overwriting backup."
                Remove-Item -Recurse "$NVIM_CONFIG_DIR.bak"
            }

            try {
                Move-Item $NVIM_CONFIG_DIR "$NVIM_CONFIG_DIR.bak"
            }
            catch {
                Write-Error "Error moving $NVIM_CONFIG_DIR to $NVIM_CONFIG_DIR.bak. Details: $($_.Exception.Message)"
                exit 1
            }
        }
    }

    Write-Host "Creating symlink from $NVIM_CONFIG_SRC to $NVIM_CONFIG_DIR"

    Write-Debug "NVIM_CONFIG_DIR: $($NVIM_CONFIG_DIR)"
    Write-Debug "NVIM_CONFIG_SRC: $($NVIM_CONFIG_SRC)"

    $SymlinkCommand = "New-Item -Path $NVIM_CONFIG_DIR -ItemType SymbolicLink -Target $NVIM_CONFIG_SRC"

    If ( -Not ( Test-IsAdmin ) ) {
        Write-Warning "Script was not run as administrator. Running symlink command as administrator."

        try {
            Run-AsAdmin -Command "$($SymlinkCommand)"
        }
        catch {
            Write-Error "Error creating symlink from $NVIM_CONFIG_SRC to $NVIM_CONFIG_DIR. Details: $($_.Exception.Message)"
        }
    }
    else {
        try {
            Invoke-Expression $SymlinkCommand
        }
        catch {
            Write-Error "Error creating symlink from $NVIM_CONFIG_SRC to $NVIM_CONFIG_DIR. Details: $($_.Exception.Message)"
            exit 1
        }
    }
}

Install-Dependencies

try {
    New-NvimConfigSymlink
}
catch {
    Write-Error "Error installing neovim configuration to path '$($NVIM_CONFIG_DIR)'."
    exit 1
}
