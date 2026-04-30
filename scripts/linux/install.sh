#!/bin/bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT=$(realpath -m "${THIS_DIR}/../../..")
LIB_DIR="${THIS_DIR}/lib"

## Source lib scripts
. "${LIB_DIR}/path.sh"
. "${LIB_DIR}/utils.sh"
. "${LIB_DIR}/install-depends.sh"
. "${LIB_DIR}/config.sh"

## Set path where script was called from
CWD=$(pwd)

## Neovim dependency packages installable with dnf
declare -a NVIM_DNF_DEPENDENCIES=(
    "ripgrep"
    "xclip"
    "git"
    "fzf"
    "wl-clipboard"
    "openssl-devel"
    "lua-devel"
    "luarocks"
    "fd-find"
)

## Neovim dependency packages installable with apt
declare -a NVIM_APT_DEPENDENCIES=(
    "build-essential"
    "ripgrep"
    "xclip"
    "wl-clipboard"
    "git"
    "fzf"
    "libssl-dev"
    "liblua5.1-0-dev"
    "luarocks"
    "fd-find"
)

## Arg defaults
DEBUG=0
APPIMG=0
BUILD_DIR="$(pwd)/build"
DEST="${HOME}/.config"
CREATE_SYMLINKS=0

## Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
    --debug | -D)
        DEBUG=1
        shift
        ;;
    --appimg)
        INSTALL_NVIM_APPIMG=1
        shift
        ;;
    --build-dir)
        BUILD_DIR="$2"
        shift 2
        ;;
    --dest)
        DEST="$2"
        shift 2
        ;;
    --symlink | -S)
        CREATE_SYMLINKS=1
        shift
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [[ $DEBUG -eq 1 ]]; then
    echo "DEBUG logging enabled"
fi

## Path for .config directory
DOTCONFIG_DIR="${HOME}/.config"

## Path to neovim configuration directory src in this repository
NVIM_CONFIG_SRC="${CWD}/config"

## Determine the OS type
OS_TYPE=$(uname -s)

## Detect container environment
#  Set CONTAINER_ENV=1 to enable
CONTAINER_ENV=${CONTAINER_ENV:-0}

## Set build directory for building from source
NEOVIM_MAKE_BUILD_DIR=$BUILD_DIR

## If $INSTALL_NVIM_APPIMG=1, add FUSE dependency
if [[ ${INSTALL_NVIM_APPIMG} -eq 1 || $INSTALL_NVIM_APPIMG == "1" ]]; then
    echo "Neovim will be installed by AppImage. Install FUSE dependency."
    if [[ ! " ${NVIM_DNF_DEPENDENCIES[@]} " =~ " fuse " ]]; then
        ## Add "fuse" to dnf dependencies
        NVIM_DNF_DEPENDENCIES+=("fuse")
    fi

    if [[ ! " ${NVIM_APT_DEPENDENCIES[@]} " =~ " fuse " ]]; then
        echo "Neovim will be installed by AppImage. Install FUSE dependency."
        ## Add "fuse" to apt dependencies
        NVIM_APT_DEPENDENCIES+=("fuse")
    fi
fi

if [[ $DEBUG -eq 1 ]]; then
    echo "[DEBUG] CWD: $CWD"
    echo "[DEBUG] OS_TYPE: $OS_TYPE"
    echo "[DEBUG] CONTAINER_ENV: $CONTAINER_ENV"
    echo "[DEBUG] NEOVIM_MAKE_BUILD_DIR: $NEOVIM_MAKE_BUILD_DIR"
fi

## Create build directory
if [[ ! -d $NEOVIM_MAKE_BUILD_DIR ]]; then
    echo "Creating build path: ${NEOVIM_MAKE_BUILD_DIR}"
    mkdir -pv "${NEOVIM_MAKE_BUILD_DIR}"
fi

function main() {
    echo ""
    echo "[ Install Neovim Configuration - ${OS_FAMILY} ($CPU_ARCH) (release: ${OS_RELEASE}, version: ${OS_VERSION}) ]"
    echo ""

    print_platform

    echo "-- [ Install dependencies"
    ## Install neovim dependencies
    if [[ ${PKG_MGR} == "dnf" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_dnf NVIM_DNF_DEPENDENCIES
    elif [[ ${PKG_MGR} == "apt" || $PKG_MGR == "apt-get" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_apt NVIM_APT_DEPENDENCIES
    else
        print_unsupported_platform
        # sleep 6
        exit 1
    fi
    eval_last $?

    ## Ensure script dependencies are installed
    check_system_dependencies
    eval_last $?

    # if [[ -d $NVIM_CONFIG_DIR ]]; then
    #     if [[ ! -L $NVIM_CONFIG_DIR ]];
    #         then echo "[WARNING] Existing neovim configuration detected at $NVIM_CONFIG_DIR. Moving to $NVIM_CONFIG_DIR.bak"

    #         mv $NVIM_CONFIG_DIR "${NVIM_CONFIG_DIR}.bak"
    #     else
    #         echo "Existing neovim configuration is a symlink. Removing link, it will be recreated by the script."
    #         rm "${NVIM_CONFIG_DIR}"
    #     fi
    # fi
    # eval_last $?

    echo "--[ Install NERDFont"
    ## Install NERDFont
    # echo "[DEBUG] Would install Nerd Fonts"
    install_nerdfont  

    if [[ $INSTALL_NVIM_APPIMG -eq 1 || $INSTALL_NVIM_APPIMG == "1" ]]; then
        # echo "[DEBUG] Would install nvim from appimg"
        ## Install neovim appimg from github
        echo "--[ Install Neovim AppImage"
        install_neovim_appimg
    else
        echo "--[ Install Neovim from source"
        # echo "[DEBUG] Would install nvim from source"
        ## Install neovim from source
        install_neovim_source
    fi

    eval_last $?
    
    echo "--[ Symlink configurations"
    ## Symlink neovim configuration
    if [[ $CREATE_SYMLINKS -eq 1 ]]; then
        REPO_CONFIGS=($(detect_repo_configs))
        symlink-config REPO_CONFIGS
    fi
}

if command -v nvim > /dev/null 2>&1; then
    echo "Neovim is already installed. Installing dependencies, backing up existing config if it exists and symlinking new config."

    REPO_CONFIGS=($(detect_repo_configs))

    symlink-config REPO_CONFIGS

    ## Install neovim dependencies
    if [[ ${PKG_MGR} == "dnf" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_dnf NVIM_DNF_DEPENDENCIES
    elif [[ ${PKG_MGR} == "apt" || $PKG_MGR == "apt-get" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_apt NVIM_APT_DEPENDENCIES
    else
        print_unsupported_platform
        # sleep 6
        exit 1
    fi
else
    ## Run script
    main
fi

if [[ ! $? -eq 0 ]]; then
    echo "[WARNING] Script exited with non-zero exit code: $?"
    # sleep 6
    exit $?
else
    echo ""
    echo "--[ Finished installing & configuring Neovim."
    echo ""
    echo "    Neovim configurations were installed to: $DOTCONFIG_DIR"
    echo "    To use a specific configuration, run NVIM_APPNAME=nvim-\$config_name nvim"
    echo ""
    echo "    For example, to use the 'nvim-noplugins' profile, run:"
    echo "      NVIM_APPNAME=nvim-noplugins nvim"
    echo ""

    exit 0
fi
