[CmdletBinding()]
Param(
    [switch]$DryRun
    # [Parameter(Mandatory=$false, HelpMessage = "Name of neovim configuration to install from the config/ directory")]
    # [string]$ConfigName = "nvim"
)

## Set path script was launched from as a variable
#  Use Set-Location to change to other paths, then
#  Set-Location $CWD to return to the originating path.
$CWD = $PWD.Path

## Path to neovim configuration
$NVIM_CONFIG_SRC = "$($CWD)\config"

## Path where neovim configuration will be symlinked to
# $NVIM_CONFIG_DIR = "$($env:USERPROFILE)\.config\$($ConfigName)"
$NVIM_CONFIG_DIR = "$($env:LOCALAPPDATA)"

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
    "FiraCode-NF",
    "FiraCode-NF-Mono",
    "cmake"
    "gcc"
    "lua"
    "luarocks",
    "python",
    "curl",
    "unzip",
    "luarocks",
    "lua-for-windows",
    "make",
    "wget",
    "gzip",
    "fd",
    "sed"
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
    
    If ( -Not ( Get-Command scoop -ErrorAction SilentlyContinue) ) {
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

    If ( -Not ( Get-Command nvim -ErrorAction SilentlyContinue ) ) {
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

function Get-NvimRepoConfigs {
    if ( -Not ( Test-Path -Path $NVIM_CONFIG_SRC -ErrorAction SilentlyContinue ) ) {
        Write-Warning "Could not find repository's config path: $NVIM_CONFIG_SRC"
        return
    }

    Write-Host "Gathering nvim configurations from path: $NVIM_CONFIG_SRC"

    try {
        $REPO_CONFIGS = Get-ChildItem -Path $NVIM_CONFIG_SRC -Directory | Select-Object -ExpandProperty FullName
    } catch {
        Write-Error "Error gathering Neovim configurations from path: $NVIM_CONFIG_SRC. Details: $($_.Exception.Messsage)"
        return
    }

    $REPO_CONFIGS
}

function New-NvimConfigSymlink {
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "Path to repository configuration that will be linked to host's configuration path.")]
        [string]$NVIM_REPO_CONFIG
    )

    if ( -Not ( $NVIM_REPO_CONFIG ) ) {
        Write-Warning "Could not find Neovim configuration in repository at path: $NVIM_REPO_CONFIG"
        return
    }

    ## Split config name from end of path, i.e. ./config/nvim-kickstart -> nvim-kickstart
    $ConfigName = Split-Path -Leaf $NVIM_REPO_CONFIG
    ## Path on host where config will be symlinked
    $SymlinkDest = Join-Path -Path $NVIM_CONFIG_DIR -ChildPath $ConfigName

    If ( $DryRun ) {
        Write-Host "[DRY RUN] Would create symlink from $NVIM_REPO_CONFIG to $SymlinkDest." -ForegroundColor Magenta
        return
    }
    else {
        ## Check if config path already exists
        If ( Test-Path $SymlinkDest ) {
            ## Check if path is directory or junction
            $Item = Get-Item $SymlinkDest

            ## Check if path is a junction
            If ( $Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint ) {
                Write-Host "Path is already a junction: $($SymlinkDest)"
                return
            }

            ## Path is a regular directory
            Write-Warning "Path already exists: $SymlinkDest. Moving to $SymlinkDest.bak"
            If ( Test-Path "$SymlinkDest.bak" ) { 
                Write-Warning "$SymlinkDest.bak already exists. Overwriting backup."
                Remove-Item -Recurse "$SymlinkDest.bak"
            }

            try {
                Move-Item $SymlinkDest "$SymlinkDest.bak"
            }
            catch {
                Write-Error "Error moving $SymlinkDest to $SymlinkDest.bak. Details: $($_.Exception.Message)"
                exit 1
            }
        }
    }

    Write-Host "Creating symlink from $NVIM_REPO_CONFIG to $SymlinkDest"

    Write-Debug "NVIM_REPO_CONFIG: $($NVIM_REPO_CONFIG)"
    Write-Debug "SymlinkDest: $($SymlinkDest)"

    $SymlinkCommand = "New-Item -Path $SymlinkDest -ItemType SymbolicLink -Target $NVIM_REPO_CONFIG"

    If ( -Not ( Test-IsAdmin ) ) {
        Write-Warning "Script was not run as administrator. Running symlink command as administrator."

        try {
            Run-AsAdmin -Command "$($SymlinkCommand)"
        }
        catch {
            Write-Error "Error creating symlink from $NVIM_REPO_CONFIG to $SymlinkDest. Details: $($_.Exception.Message)"
        }
    }
    else {
        try {
            Invoke-Expression $SymlinkCommand
        }
        catch {
            Write-Error "Error creating symlink from $NVIM_REPO_CONFIG to $SymlinkDest. Details: $($_.Exception.Message)"
            exit 1
        }
    }
}

Install-Dependencies

## Link configurations
$REPO_CONFIGS = Get-NvimRepoConfigs

ForEach ( $config in $REPO_CONFIGS ) {
    Write-Host "Creating symlink from $config to $NVIM_CONFIG_DIR"
    try {
        New-NvimConfigSymlink -NVIM_REPO_CONFIG $config
    } catch {
        Write-Error "Failed creating symlink for config $config. Details: $($_.Exception.Message)"
        continue
    }
}

Write-Host @"
Neovim installed.

Multiple configurations were installed at path: $NVIM_CONFIG_DIR.

To launch Neovim with a specific configuration, use the `$NVIM_APPNAME environment variable. For example,
to launch the 'noplugins' configuration:

    `$NVIM_APPNAME = 'noplugins' neovim
"@

# try {
#     New-NvimConfigSymlink
# }
# catch {
#     Write-Error "Error installing neovim configuration to path '$($NVIM_CONFIG_DIR)'."
#     exit 1
# }
