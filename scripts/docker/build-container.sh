#!/bin/bash

if ! command -v docker > /dev/null 2>&1; then
    echo "[WARNING] Docker is not installed."
    exit 1
fi

echo ""
echo "Building Neovim configuration in Docker container..."
echo ""

docker build -t neovim-setup .
