#!/bin/bash

## Set path where script was called from
CWD=$(pwd)
# echo "[DEBUG] CWD: ${CWD}"

## Path to neovim configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
# echo "[DEBUG] Neovim config path: ${NVIM_CONFIG_DIR}"

function return_to_root() {
    cd $CWD
}

if ! command -v nvim > /dev/null 2>&1; then
    echo "[WARNING] Neovim is not installed."
    
    sudo apt update -y && sudo apt install -y neovim
fi

echo ""
echo "[ Install Neovim Configuration - Debian Linux ]"
echo ""

if [[ -d $NVIM_CONFIG_DIR ]]; then
    echo "[WARNING] Existing neovim configuration detected at $NVIM_CONFIG_DIR. Moving to $NVIM_CONFIG_DIR.bak"

    mv $NVIM_CONFIG_DIR "${NVIM_CONFIG_DIR}.bak"
fi

## Change path back to starting point
return_to_root
