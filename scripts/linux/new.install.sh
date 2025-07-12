#!/bin/bash

## Set path where script was called from
CWD=$(pwd)

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

## Neovim dependency packages installable with dnf
declare -a NVIM_DNF_DEPENDENCIES=(
    "ripgrep"
    "xclip"
    "git"
    "fzf"
    "openssl-dev"
    "compat-lua-devel-5.1.5"
    "luarocks"
    "fd-find"
)
declare -a NVIM_DNF_GROUP_DEPENDENCIES=(
    "Development Tools"
    "Development Libraries"
)

## Neovim dependency packages installable with apt
declare -a NVIM_APT_DEPENDENCIES=(
    "build-essential"
    "ripgrep"
    "xclip"
    "git"
    "fzf"
    "libssl-dev"
    "liblua5.1-0-dev"
    "luarocks"
    "fd-find"
)

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

function exit_with_error() {
    ## When the script errors, exit preemptively and cleanup the build directory
    echo "[ERROR] Exiting prematurely, doing script cleanup."

    exit 1
}

function eval_last() {
    ## Evaluate the last exit code
    if [[ $1 -eq 0 ]]; then
        return
    elif [[ $1 -eq 1 ]]; then
        echo "Non-zero exit code on the last command. Exiting."

        exit 1
    fi
}

function return_to_root() {
    cd $CWD
}

# Determine OS release and family
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_RELEASE=$NAME
    OS_VERSION=${VERSION_ID:-"Unknown"}
    OS_FAMILY="Unknown"

    # Check for ID_LIKE or use ID as a fallback
    if [ -n "$ID_LIKE" ]; then
        if echo "$ID_LIKE" | grep -q "debian"; then
            OS_FAMILY="Debian-family"
        elif echo "$ID_LIKE" | grep -q "rhel"; then
            OS_FAMILY="RedHat-family"
        fi
    elif [ -n "$ID" ]; then
        if echo "$ID" | grep -qE "debian|ubuntu"; then
            OS_FAMILY="Debian-family"
        elif echo "$ID" | grep -qE "rhel|fedora|centos"; then
            OS_FAMILY="RedHat-family"
        fi
    fi
else
    OS_RELEASE="Unknown"
    OS_VERSION="Unknown"
    OS_FAMILY="Unknown"
fi

## Determine the CPU architecture
CPU_ARCH=$(uname -m)

## Export the variables
export OS_TYPE OS_RELEASE OS_FAMILY CPU_ARCH

## Set PKG_MGR var
if [[ $OS_FAMILY == "RedHat-family" ]]; then
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] RedHat-family OS detected."
    fi

    if ! command -v dnf >/dev/null 2>&1; then
        echo "dnf not detected. Trying yum"

        if ! command -v yum 2 >/dev/null &>1; then
            echo "[ERROR] RedHat family OS was detected, but script could not find dnf or yum package manager..."

            exit 1
        else
            PKG_MGR="yum"
        fi
    else
        PKG_MGR="dnf"
    fi
elif [[ $OS_FAMILY == "Debian-family" ]]; then
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] Debian-family OS detected."
    fi

    if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
        echo "Script detected a container environment. Fallback to apt-get"
        PKG_MGR="apt-get"
    else
        PKG_MGR="apt"
    fi
else
    echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
    # if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
    ## Pause in a Docker environment to see output
    # sleep 6
    # fi

    exit 1
fi

## Check if host platform is an LXC container
if grep -q 'container=lxc' /proc/1/environ 2>/dev/null; then
    IS_LXC="true"
else
    IS_LXC="false"
fi

## Create a print-able platform string
PLATFORM_STR="\n
\t[ Platform Info ]\n
\tCPU: ${CPU_ARCH}\n
\tOS Family: ${OS_FAMILY}\n
\tRelease: ${OS_RELEASE}\n
\tRelease Version: ${OS_VERSION}\n
\tPackage Manager: ${PKG_MGR}\n
\tLXC container: ${IS_LXC}\n
"

function print_platform() {
    echo -e $PLATFORM_STR
}

print_platform

function print_unsupported_platform() {
    echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
}

function install_nerdfont() {
    ## Install the FiraCode nerd font

    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    FONT_DIR="$HOME/.local/share/fonts"
    TEMP_DIR="/tmp/firacode-nerdfont"

    if [[ ! -d "$FONT_DIR/FiraCode" ]]; then
        echo ""
        echo "[ Neovim Setup - Install NerdFont ]"
        echo ""
    else
        return
    fi

    if [[ ! -d $FONT_DIR ]]; then
        echo "Creating directory '$FONT_DIR'"
        mkdir -pv "$FONT_DIR"
    fi

    if [[ ! -d $TEMP_DIR ]]; then
        echo "Creating directory '$TEMP_DIR'"
        mkdir -pv "$TEMP_DIR"
    fi

    if [[ ! -f "${TEMP_DIR}/FiraCode.zip" ]]; then
        echo "Downloading FiraCode font..."
        cd $TEMP_DIR

        curl -LO "$FONT_URL"
    fi

    if [[ ! -d "${TEMP_DIR}/FiraCode" ]]; then
        echo "Unzipping FiraCode font..."

        unzip -o FiraCode.zip -d FiraCode
    fi

    if [[ ! -d "${FONT_DIR}/FiraCode" ]]; then
        echo "Installing FiraCode to $FONT_DIR"

        cp -R "${TEMP_DIR}/FiraCode" "${FONT_DIR}"
    fi

    echo ""
    echo "Refreshing font cache"
    fc-cache -fv

    ## Change path back to starting point
    return_to_root
}

function install_dependencies_apt() {
    ## Install all neovim dependencies

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ($PKG_MGR) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo $PKG_MGR install -y "${NVIM_APT_DEPENDENCIES[@]}"

    if ! command -v nvm --version > /dev/null 2>&1 && [ ! -d "$HOME/.nvm" ]; then
        echo "[WARNING] nvm is not installed."

        ## Download & install nvm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        
        eval_last $?
    fi

    ## Load NVM
    echo "Loading nvm"
    NVM_DIR="$HOME/.nvm"

    ## This loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    ## This loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    if ! command -v npm > /dev/null 2>&1; then
        echo "[WARNING] node is not installed."

        nvm install --lts
        eval_last $?
        nvm alias default lts/*
    fi

    if ! command -v tree-sitter --version > /dev/null 2>&1; then
        echo "[WARNING] tree-sitter is not installed."
        npm install -g tree-sitter-cli
    fi

    ## Install neovim package for npm
    echo "Installing neovim with npm"
    npm install -g neovim
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Error installing neovim with npm"
    fi
}

function install_dependencies_dnf() {
    ## Install all neovim dependencies

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ($PKG_MGR) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo dnf update -y
    sudo dnf install -y "${NVIM_DNF_DEPENDENCIES[@]}"
    
    for dnf_group in "${NVIM_DNF_GROUP_DEPENDENCIES[@]}"; do
        echo "Installing DNF group: ${dnf_group}"
        sudo dnf group install -y "${dnf_group}"
    done

    if ! command -v nvm > /dev/null 2>&1; then
        echo "[WARNING] nvm is not installed."

        ## Download & install nvm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

        source ~/.bashrc
    fi

    if ! command -v npm > /dev/null 2>&1; then
        echo "[WARNING] node is not installed."

        nvm install --lts
        nvm alias default lts/*
    fi

    if ! command -v tree-sitter --version > /dev/null 2>&1; then
        echo "[WARNING] tree-sitter is not installed."
        npm install -g tree-sitter-cli
    fi

    ## Install neovim package for npm
    echo "Installing neovim with npm"
    npm install -g neovim
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Error installing neovim with npm"
    fi
}

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
        abs_path=$(cd "./config/$conf" && pwd)
        
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

    for _conf in config/*; do
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
        install_dependencies_dnf
    elif [[ ${PKG_MGR} == "apt" || $PKG_MGR == "apt-get" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_apt
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
        symlink-config $REPO_CONFIGS
    fi
}

if command -v nvim > /dev/null 2>&1; then
    echo "Neovim is already installed. Installing dependencies, backing up existing config if it exists and symlinking new config."

    REPO_CONFIGS=($(detect_repo_configs))

    symlink-config $REPO_CONFIGS

    ## Install neovim dependencies
    if [[ ${PKG_MGR} == "dnf" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_dnf
    elif [[ ${PKG_MGR} == "apt" || $PKG_MGR == "apt-get" ]]; then
        # echo "[DEBUG] Would install dependencies with $PKG_MGR"
        install_dependencies_apt
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

    exit 0
fi
