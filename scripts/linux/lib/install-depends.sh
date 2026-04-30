#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "${THIS_DIR}/path.sh"

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
    
    ## Expects array name as first parameter: install_dependencies_apt NVIM_APT_DEPENDENCIES
    local -n apt_deps=$1

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ($PKG_MGR) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo apt update
    sudo apt install -y "${apt_deps[@]}"

    if ! command -v nvm >/dev/null 2>&1; then
        echo "[WARNING] nvm is not installed."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        source ~/.bashrc
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "[WARNING] node is not installed."
        nvm install --lts
        nvm alias default lts/*
    fi

    if ! command -v tree-sitter >/dev/null 2>&1; then
        echo "[WARNING] tree-sitter is not installed."
        npm install -g tree-sitter-cli
    fi

    echo "Installing neovim with npm"
    npm install -g neovim
}

function install_dependencies_dnf() {
    ## Install all neovim dependencies
    
    ## Expects array name as first parameter: install_dependencies_dnf NVIM_DNF_DEPENDENCIES
    local -n dnf_deps=$1

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ($PKG_MGR) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo dnf update -y
    sudo dnf install -y "${dnf_deps[@]}"
    sudo dnf install -y @development-tools

    if ! command -v nvm >/dev/null 2>&1; then
        echo "[WARNING] nvm is not installed."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        source ~/.bashrc
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "[WARNING] node is not installed."
        nvm install --lts
        nvm alias default lts/*
    fi

    if ! command -v tree-sitter >/dev/null 2>&1; then
        echo "[WARNING] tree-sitter is not installed."
        npm install -g tree-sitter-cli
    fi

    echo "Installing neovim with npm"
    npm install -g neovim
}
