#!/bin/bash

## Build and test Neovim configurations in Docker
## Usage: ./build-and-test.sh [config-name]

set -e

CONFIG_NAME="${1:-nvim}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================="
echo "Building Neovim container for: ${CONFIG_NAME}"
echo "=========================================="

cd "${SCRIPT_DIR}"

## Check if config exists
if [ ! -d "${REPO_ROOT}/config/${CONFIG_NAME}" ]; then
    echo "Error: Config '${CONFIG_NAME}' not found in ${REPO_ROOT}/config/"
    echo ""
    echo "Available configs:"
    ls -1 "${REPO_ROOT}/config/" | grep "^nvim"
    exit 1
fi

## Build the container
echo ""
echo "Building container..."
CONFIG_NAME="${CONFIG_NAME}" docker compose build

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "Build complete for: ${CONFIG_NAME}"
echo "=========================================="
echo ""
echo "To run the container:"
echo "  CONFIG_NAME=${CONFIG_NAME} docker compose run --rm nvim"
echo ""
echo "Or directly:"
echo "  docker compose run --rm nvim"
echo ""
echo "Inside the container, run:"
echo "  nvim              # Start Neovim"
echo "  nvim --version    # Check version"
echo "  :checkhealth      # Run health checks (inside nvim)"
echo ""
