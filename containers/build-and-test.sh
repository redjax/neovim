#!/bin/bash

## Build and test Neovim configurations in Docker
## Usage: ./build-and-test.sh [config-name] [base-image]
##   config-name: nvim, nvim-lazyvim, nvim-work, nvim-noplugins, nvim-kickstart (default: nvim)
##   base-image:  debian:stable-slim, ubuntu:24.04, fedora:41, archlinux:base, alpine:3.21 (default: debian:stable-slim)

set -e

CONFIG_NAME="${1:-nvim}"
BASE_IMAGE="${2:-debian:stable-slim}"
BASE_IMAGE_TAG="${BASE_IMAGE%%:*}"
BASE_IMAGE_TAG="${BASE_IMAGE_TAG##*/}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================="
echo "Building Neovim container"
echo "  Config: ${CONFIG_NAME}"
echo "  Distro: ${BASE_IMAGE}"
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
BASE_IMAGE="${BASE_IMAGE}" BASE_IMAGE_TAG="${BASE_IMAGE_TAG}" CONFIG_NAME="${CONFIG_NAME}" docker compose build

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "Build complete: ${CONFIG_NAME} on ${BASE_IMAGE}"
echo "=========================================="
echo ""
echo "To run the container:"
echo "  BASE_IMAGE=${BASE_IMAGE} BASE_IMAGE_TAG=${BASE_IMAGE_TAG} CONFIG_NAME=${CONFIG_NAME} docker compose run --rm nvim bash"
echo ""
echo "Inside the container, run:"
echo "  nvim              # Start Neovim"
echo "  nvim --version    # Check version"
echo "  :checkhealth      # Run health checks (inside nvim)"
echo ""
