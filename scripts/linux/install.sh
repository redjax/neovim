#!/bin/bash

## Set path where script was called from
CWD=$(pwd)
# echo "[DEBUG] CWD: ${CWD}"

# Determine the OS type
OS_TYPE=$(uname -s)

function eval_last() {
    ## Evaluate the last exit code
    if [[ $1 -eq 0 ]]; then
        return
    elif [[ $1 -eq 1 ]]; then
        echo "Non-zero exit code on the last command. Exiting."
        exit 1
    fi
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

# Determine the CPU architecture
CPU_ARCH=$(uname -m)

# Export the variables
export OS_TYPE OS_RELEASE OS_FAMILY CPU_ARCH

## Uncomment to debug print values
# echo "[DEBUG] OS_TYPE: $OS_TYPE"
# echo "[DEBUG] OS_RELEASE: $OS_RELEASE"
# echo "[DEBUG] OS_VERSION: $OS_VERSION"
# echo "[DEBUG] OS_FAMILY: $OS_FAMILY"
# echo "[DEBUG] CPU_ARCH: $CPU_ARCH"

if [[ $OS_FAMILY == "RedHat-family" ]]; then
    echo "[DEBUG] RedHat-family OS detected."
    if ! command -v dnf > /dev/null 2>&1; then
        echo "dnf not detected. Trying yum"

        if ! command -v yum > /dev/null 2&>1; then
            echo "[ERROR] RedHat family OS was detected, but script could not find dnf or yum package manager..."
            exit 1
        else
            PKG_MGR="yum"
        fi
    else
        PKG_MGR="dnf"
    fi
elif [[ $OS_FAMILY == "Debian-family" ]]; then
    echo "[DEBUG] Debian-family OS detected."
    PKG_MGR="apt"
else
    echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
    exit 1
fi

## Create a print-able platform string
PLATFORM_STR="\n
[ Platform Info ]\n
CPU: ${CPU_ARCH}\n
OS Family: ${OS_FAMILY}\n
Release: ${OS_RELEASE}\n
Release Version: ${OS_VERSION}\n
Package Manager: ${PKG_MGR}\n
"

function print_platform() {
    echo -e $PLATFORM_STR
}

function print_unsupported_platform() {
    echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
}

# print_platform

## Check if host platform is an LXC container
if grep -q 'container=lxc' /proc/1/environ 2>/dev/null; then
    IS_LXC="true"
else
    IS_LXC="false"
fi

## Path for .config directory
DOTCONFIG_DIR="${HOME}/.config"
## Path to neovim configuration directory src in this repository
NVIM_CONFIG_SRC="${CWD}/config/nvim"
# echo "[DEBUG] Neovim config source: ${NVIM_CONFIG_SRC}"

## Path to neovim configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
# echo "[DEBUG] Neovim config path: ${NVIM_CONFIG_DIR}"

## Neovim dependency packages installable with dnf
declare -a NVIM_DNF_DEPENDENCIES=("ripgrep" "xclip" "git" "fzf" "openssl-dev" "fuse")
declare -a NVIM_DNF_GROUP_DEPENDENCIES=("Development Tools" "Development Libraries")
# echo "[DEBUG] Neovim dependencies installable with apt: ${NVIM_DNF_DEPENDENCIES[@]}"

## Neovim dependency packages installable with apt
declare -a NVIM_APT_DEPENDENCIES=("build-essential" "ripgrep" "xclip" "git" "fzf" "libssl-dev" "fuse")

function return_to_root() {
    cd $CWD
}

function install-nerdfont() {
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

function install-dependencies-apt() {
    ## Install all neovim dependencies

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies (apt) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo apt update -y
    sudo apt install -y "${NVIM_APT_DEPENDENCIES[@]}"

    if ! command -v nvm > /dev/null 2>&1; then
        echo "[WARNING] nvm is not installed."

        ## Download & install nvm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

        ## Load NVM
        echo "Loading nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    ## Load NVM
    echo "Loading nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    eval_last $?

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
}

function install-dependencies-dnf() {
    ## Install all neovim dependencies

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies (dnf) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo dnf update -y
    sudo dnf install -y "${NVIM_DNF_DEPENDENCIES[@]}"
    sudo dnf group install -y "${NVIM_DNF_DEPENDENCIES[@]}"

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
}

function install-neovim-appimg() {
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

function symlink-config() {
    ## Create symbolic link from repository's config/nvim path to ~/.config/nvim

    if [[ ! -d "${DOTCONFIG_DIR}" ]]; then
	echo "Path '${DOTCONFIG_DIR}' does not exist. Creating."
	mkdir -pv "${DOTCONFIG_DIR}"
    else	
	if [[ -d $NVIM_CONFIG_DIR ]]; then
            echo "Neovim config already exists at $NVIM_CONFIG_DIR"
        elif [ -L "${NVIM_CONFIG_DIR}" ]; then
            echo "Neovim path is a symlink. Removing link"
            rm "${NVIM_CONFIG_DIR}"
        else
            echo "Neovim path is not a symlink. Backing up to ${NVIM_CONFIG_DIR}.bak"
            mv "${NVIM_CONFIG_DIR}" "${NVIM_CONFIG_DIR}.bak"
        fi
    fi

    echo "Creating symlink from ${NVIM_CONFIG_SRC} to ${NVIM_CONFIG_DIR}"
    ln -s "${NVIM_CONFIG_SRC}" "${NVIM_CONFIG_DIR}"
}

######################
# Check Dependencies #
######################

## Check if curl is installed
if ! command -v curl > /dev/null 2>&1; then
    echo "[WARNING] curl is not installed."

    if [[ $PKG_MGR == "dnf" ]]; then
        sudo dnf update -y && sudo dnf install -y curl
    elif [[ $PKG_MGR == "apt" ]]; then
        sudo apt update -y && sudo apt install -y curl
    else
        print_unsupported_platform
        exit 1
    fi
fi

## Check if unzip is installed
if ! command -v unzip > /dev/null 2>&1; then
    echo "[WARNING] unzip is not installed."

    if [[ $PKG_MGR == "dnf" ]]; then
        sudo dnf update -y && sudo dnf install -y unzip
    elif [[ $PKG_MGR == "apt" ]]; then
        sudo apt update -y && sudo apt install -y unzip
    else
        print_unsupported_platform
        exit 1
    fi
fi

## Check if fontconfig is installed
if ! command -v fc-cache > /dev/null 2>&1; then
    echo "[WARNING] fontconfig is not installed."

    if [[ $PKG_MGR == "dnf" ]]; then
        sudo dnf update -y && sudo dnf install -y fontconfig
    elif [[ $PKG_MGR == "apt" ]]; then
        sudo apt update -y && sudo apt install -y fontconfig
    else
        print_unsupported_platform
        exit 1
    fi
fi

#########
# Logic #
#########

function main() {
    echo ""
    echo "[ Install Neovim Configuration - ${OS_FAMILY} ($CPU_ARCH) (release: ${OS_RELEASE}, version: ${OS_VERSION}) ]"
    echo ""

    print_platform

    if [[ -d $NVIM_CONFIG_DIR ]]; then
        if [[ ! -L $NVIM_CONFIG_DIR ]];
            then echo "[WARNING] Existing neovim configuration detected at $NVIM_CONFIG_DIR. Moving to $NVIM_CONFIG_DIR.bak"

            mv $NVIM_CONFIG_DIR "${NVIM_CONFIG_DIR}.bak"
        else
            echo "Existing neovim configuration is a symlink. Leaving in place."
        fi
    fi
    eval_last $?

    ## Install NERDFont
    install-nerdfont

    ## Install neovim dependencies
    if [[ ${PKG_MGR} == "dnf" ]]; then
        install-dependencies-dns
    elif [[ ${PKG_MGR} == "apt" ]]; then
        install-dependencies-apt
    else
        print_unsupported_platform

        exit 1
    fi    

    ## Install neovim from github
    install-neovim-appimg

    ## Symlink neovim configuration
    symlink-config
}

## Run script
main

if [[ ! $? -eq 0 ]]; then
    echo "[WARNING] Script exited with non-zero exit code: $?"
    exit $?
fi
