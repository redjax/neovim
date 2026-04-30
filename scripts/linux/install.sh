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

function install_neovim_appimg() {
    ## Install Neovim from Github release

    TEMP_DIR="/tmp/neovim"
    NEOVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"

    echo ""
    echo "[ Neovim Setup - Install neovim (appimg) ]"
    echo ""

    if [[ ! -d $TEMP_DIR ]]; then
        echo "Creating directory: $TEMP_DIR"

        mkdir -pv "${TEMP_DIR}"
    fi

    cd $TEMP_DIR

    if [[ ! -f "${TEMP_DIR}/nvim.appimage" ]]; then
        echo "Downloading latest stable release from Github"
        curl -LO "${NEOVIM_DOWNLOAD_URL}"
    fi

    ## Make it executable
    chmod +x nvim.appimage

    # Replace the old version
    sudo mv nvim.appimage /usr/bin/nvim

    # Verify the update
    nvim --version

    return_to_root
}

function install_neovim_source() {
    
    declare -a APT_DEPENDS=("git" "ninja-build" "gettext" "libtool" "libtool-bin" "autoconf" "automake" "cmake" "g++" "pkg-config" "unzip" "curl" "doxygen")
    declare -a DNF_DEPENDS=("git" "ninja-build" "libtool" "autoconf" "automake" "cmake" "gcc" "gcc-c++" "make" "pkgconfig" "unzip" "patch" "gettext" "curl")

    if [[ $PKG_MGR == "dnf" ]]; then
        echo "Installing build tools for neovim with dnf"
        sudo $PKG_MGR install -y "${DNF_DEPENDS[@]}"
        eval_last $?
    elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
        echo "Installing build tools for neovim with apt"
        sudo $PKG_MGR install -y "${APT_DEPENDS[@]}"
        eval_last $?
    else
        echo "[WARNING] Building neovim from source with package manager '${PKG_MGR}' is not supported."
        # if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
            ## Pause in a Docker environment to see output
            # sleep 6
        # fi

        exit 1
    fi

    cd $NEOVIM_MAKE_BUILD_DIR
    eval_last $?

    if [[ ! -d "neovim" ]]; then
        echo "Cloning neovim repeository"
        git clone https://github.com/neovim/neovim.git
    else
        echo "Neovim repository already exists at ${NEOVIM_MAKE_BUILD_DIR}/neovim. Changes will be pulled, and Neovim will be rebuilt."
    fi

    cd neovim
    eval_last $?
    echo "Running a git pull to get any changes"
    git pull
    eval_last $?

    ## Remove Make cache if in container
    if [[ $CONTAINER_ENV -eq 1 || "${CONTAINER_ENV}" == "1" ]]; then
        if [[ -d "${NEOVIM_MAKE_BUILD_DIR}/neovim/cmake.deps/CMakeLists.txt" ]]; then
            echo "[WARNING] Previous CMake build detected while building in container environment.
            Removing ${NEOVIM_MAKE_BUILD_DIR}/neovim/cmake.deps directory for a clean build.
            "

            rm -r "${NEOVIM_MAKE_BUILD_DIR}/neovim/cmake.deps}"
            eval_last $?
        fi
    fi
    
    echo "Building Neovim"
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    eval_last $?

    echo "Installing Neovim after building source"
    sudo make install
    eval_last $?
    # if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
        ## Pause in a Docker environment to see output
        # sleep 6
    # fi

    echo "[SUCCESS] Neovim installed" 
}

function symlink-config() {
    ## Create symbolic link from repository's config/nvim path to ~/.config/nvim
    REPO_CONFIGS=$1

    if [[ ${#REPO_CONFIGS[@]} -eq 0 ]]; then
      echo "[ERROR] Did not find any neovim configurations at path: ${CWD}/config"
      return 1
    fi

    ## Symlink discovered configurations
    for conf in "${REPO_CONFIGS[@]}"; do
        ## Get absolute path to config file
        abs_path=$(cd "${CWD}/config/$conf" && pwd)
        
        if [[ $DEBUG -eq 1 ]]; then
            echo "[DEBUG] Config absolute path: $abs_path"
        fi

        ## Check if directory exists
        if [[ -d "$DOTCONFIG_DIR/$conf" ]]; then
            echo "Neovim config already exists at $DOTCONFIG_DIR/$conf"
            continue
        elif [ -L "$DOTCONFIG_DIR/$conf" ]; then
            echo "Path is already a symlink: $DOTCONFIG_DIR/$conf"
            continue
        else

            echo "Creating symlink: $abs_path --> $DOTCONFIG_DIR/$conf"
            
            ## Create symlink
            ln -s "${abs_path}" "$DOTCONFIG_DIR/$conf"
            if [[ ! $? -eq 0 ]]; then
            echo "[ERROR] Could not create symlink for config: $conf to path: $DOTCONFIG_DIR/$conf"
            continue
            fi
        fi
    done
}

######################
# Check Dependencies #
######################

function check_system_dependencies() {
    ## Check if curl is installed
    if ! command -v curl > /dev/null 2>&1; then
        echo "[WARNING] curl is not installed."

        if [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y curl
        elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
            sudo $PKG_MGR install -y curl
        else
            print_unsupported_platform
            # sleep 6
            exit 1
        fi
    fi

    ## Check if unzip is installed
    if ! command -v unzip > /dev/null 2>&1; then
        echo "[WARNING] unzip is not installed."

        if [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y unzip
        elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
            sudo $PKG_MGR install -y unzip
        else
            print_unsupported_platform
            # sleep 6
            exit 1
        fi
    fi

    ## Check if fontconfig is installed
    if ! command -v fc-cache > /dev/null 2>&1; then
        echo "[WARNING] fontconfig is not installed."

        if [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y fontconfig
        elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
            sudo $PKG_MGR install -y fontconfig
        else
            print_unsupported_platform
            # sleep 6
            exit 1
        fi
    fi
}

function pkg_mgr_update() {
    if [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
        echo "Updating packages with $PKG_MGR"
        sudo $PKG_MGR update -y
    elif [[ $PKG_MGR == "dnf" || $PKG_MGR == "yum" ]]; then
        echo "Updating packages with $PKG_MGR"
        sudo $PKG_MGR update -y
    fi
}

function detect_repo_configs() {
    ## Iterate over config directory & load discovered config dirs into NVIM_CONFIGS
    NVIM_CONFIGS=(

    )
    echo "Getting configurations from path: ${CWD}/config/" >&2

    for _conf in "${CWD}"/config/*; do
    if [ -d "$_conf" ]; then
        if [[ $DEBUG -eq 1 ]]; then
            echo "[DEBUG] Adding config: $_conf" >&2
        fi
        NVIM_CONFIGS+=("${_conf##*/}")
    fi
    done

    ## Return the array. Assign like: $NVIM_CONFIGS=($(detect_repo_configs))
    echo "${NVIM_CONFIGS[@]}"
}

#########
# Logic #
#########

function main() {
    echo ""
    echo "[ Install Neovim Configuration - ${OS_FAMILY} ($CPU_ARCH) (release: ${OS_RELEASE}, version: ${OS_VERSION}) ]"
    echo ""

    print_platform

    pkg_mgr_update

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
