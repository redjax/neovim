#!/bin/bash

## Exit immediately if a command exits with a non-zero status
set -e

## Set path where script was called from
CWD=$(pwd)
# echo "[DEBUG] CWD: ${CWD}"

## Path to neovim configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
# echo "[DEBUG] Neovim config path: ${NVIM_CONFIG_DIR}"

## Neovim dependency packages installable with apt
declare -a NVIM_APT_DEPENDENCIES=("build-essential")
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
        echo "[ Neovim Setup - Install NerdFont ]"
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
    
}

## Run script
main

if [[ ! $? -eq 0 ]]; then
    echo "[WARNING] Script exited with non-zero exit code: $?"
    exit $?
fi
