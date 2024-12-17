#!/bin/bash

## Set path where script was called from
CWD=$(pwd)
# echo "[DEBUG] CWD: ${CWD}"

## Path to neovim configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
# echo "[DEBUG] Neovim config path: ${NVIM_CONFIG_DIR}"

## Neovim dependency packages installable with apt
declare -a NVIM_APT_DEPENDENCIES=("build-essential" "ripgrep" "xclip" "git" "fzf" "libssl-dev" "fuse")
# echo "[DEBUG] Neovim dependencies installable with apt: ${NVIM_APT_DEPENDENCIES[@]}"

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

function install-dependencies() {
    ## Install all neovim dependencies

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ]"
    echo ""

    sudo apt update -y
    sudo apt install -y "${NVIM_APT_DEPENDENCIES[@]}"

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
}

function install-neovim() {
    ## Install Neovim from Github release

    TEMP_DIR="/tmp/neovim"
    NEOVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"

    # if command -v nvim > /dev/null 2>&1; then
    #     echo ""
    #     echo "Neovim is already installed."
    #     # echo "[DEBUG] Neovim path: " $(which nvim)
    #     echo ""

    #     return
    # fi

    # if [[ -f /usr/bin/nvim ]]; then
    #     echo ""
    #     echo "Neovim is already installed at path /usr/bin/nvim"
        
    #     return
    # fi

    echo ""
    echo "[ Neovim Setup - Install neovim ]"
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

######################
# Check Dependencies #
######################

## Check if neovim is installed
if ! command -v nvim > /dev/null 2>&1; then
    echo "[WARNING] Neovim is not installed."
    
    sudo apt update -y && sudo apt install -y neovim
fi

## Check if curl is installed
if ! command -v curl > /dev/null 2>&1; then
    echo "[WARNING] curl is not installed."

    sudo apt update -y && sudo apt install -y curl
fi

## Check if unzip is installed
if ! command -v unzip > /dev/null 2>&1; then
    echo "[WARNING] unzip is not installed."

    sudo apt update -y && sudo apt install -y unzip
fi

## Check if fontconfig is installed
if ! command -v fc-cache > /dev/null 2>&1; then
    echo "[WARNING] fontconfig is not installed."

    sudo apt update -y && sudo apt install -y fontconfig
fi

#########
# Logic #
#########

function main() {
    echo ""
    echo "[ Install Neovim Configuration - Debian Linux ]"
    echo ""

    if [[ -d $NVIM_CONFIG_DIR ]]; then
        echo "[WARNING] Existing neovim configuration detected at $NVIM_CONFIG_DIR. Moving to $NVIM_CONFIG_DIR.bak"

        mv $NVIM_CONFIG_DIR "${NVIM_CONFIG_DIR}.bak"
    fi

    ## Install NERDFont
    install-nerdfont

    ## Install neovim dependencies
    install-dependencies

    ## Install neovim from github
    install-neovim
}

## Run script
main

if [[ ! $? -eq 0 ]]; then
    echo "[WARNING] Script exited with non-zero exit code: $?"
    exit $?
fi
