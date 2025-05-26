#!/bin/bash

if ! command -v docker > /dev/null 2>&1; then
    echo "[WARNING] Docker is not installed."
    exit 1
fi

echo ""
echo "Starting Neovim Docker container"
echo ""

docker run --name neovim-setup --rm -it neovim-setup /bin/bash
