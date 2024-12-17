#!/bin/bash

## Set path where script was called from
CWD=$(pwd)

if ! command -v neovim; then
    echo "[WARNING] Neovim is not installed."
    exit 1
fi

echo ""
echo "[ Install Neovim - Debian Linux ]"
echo ""
