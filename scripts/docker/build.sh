#!/bin/bash

## Build Neovim configuration Docker image
## Usage: ./scripts/docker/build.sh [OPTIONS] [config-name] [base-image]
##   config-name: nvim, nvim-lazyvim, nvim-work, nvim-noplugins, nvim-kickstart (default: nvim)
##   base-image:  debian:stable-slim, ubuntu:24.04, fedora:42, archlinux:base (default: debian:stable-slim)

set -e

usage() {
    echo "Usage: $(basename "$0") [OPTIONS] [config-name] [base-image]"
    echo ""
    echo "Build a Neovim configuration Docker image."
    echo ""
    echo "Arguments:"
    echo "  config-name   Neovim config to test (default: nvim)"
    echo "                Options: nvim, nvim-lazyvim, nvim-work, nvim-noplugins, nvim-kickstart"
    echo "  base-image    Docker base image / distro (default: debian:stable-slim)"
    echo "                Examples: debian:stable-slim, ubuntu:24.04, fedora:42, archlinux:base"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0")                              # Build nvim on debian:stable-slim"
    echo "  $(basename "$0") nvim-lazyvim                 # Build nvim-lazyvim on debian:stable-slim"
    echo "  $(basename "$0") nvim ubuntu:24.04            # Build nvim on Ubuntu 24.04"
    echo "  $(basename "$0") nvim-work fedora:42          # Build nvim-work on Fedora 42"
}

## Check for help flag
for arg in "$@"; do
    case "$arg" in
        -h|--help)
            usage
            exit 0
            ;;
    esac
done

CONFIG_NAME="${1:-nvim}"
BASE_IMAGE="${2:-debian:stable-slim}"
## Derive a short tag from the image name (e.g. "debian:stable-slim" -> "debian")
BASE_IMAGE_TAG="${BASE_IMAGE%%:*}"
BASE_IMAGE_TAG="${BASE_IMAGE_TAG##*/}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONTAINER_DIR="${REPO_ROOT}/containers"
COMPOSE_FILE="${CONTAINER_DIR}/compose.yml"

if ! command -v docker > /dev/null 2>&1; then
    echo "[ERROR] docker is not installed."
    exit 1
fi

if ! docker compose version > /dev/null 2>&1; then
    echo "[ERROR] docker compose is not installed."
    exit 1
fi

## Check if compose file exists
if [[ ! -f "${COMPOSE_FILE}" ]]; then
    echo "[ERROR] compose.yml not found at path: ${COMPOSE_FILE}"
    exit 1
fi

## Check if the requested config exists
if [[ ! -d "${REPO_ROOT}/config/${CONFIG_NAME}" ]]; then
    echo "[ERROR] Config '${CONFIG_NAME}' not found in ${REPO_ROOT}/config/"
    echo ""
    echo "Available configs:"
    ls -1 "${REPO_ROOT}/config/" | grep "^nvim"
    exit 1
fi

echo "=========================================="
echo "Building Neovim container"
echo "  Config: ${CONFIG_NAME}"
echo "  Distro: ${BASE_IMAGE}"
echo "=========================================="

cd "${CONTAINER_DIR}"
BASE_IMAGE="${BASE_IMAGE}" BASE_IMAGE_TAG="${BASE_IMAGE_TAG}" CONFIG_NAME="${CONFIG_NAME}" docker compose build

if [[ $? -ne 0 ]]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "Build complete: ${CONFIG_NAME} on ${BASE_IMAGE}"
echo "=========================================="
echo ""
echo "To run the container:"
echo "  cd containers && BASE_IMAGE=${BASE_IMAGE} BASE_IMAGE_TAG=${BASE_IMAGE_TAG} CONFIG_NAME=${CONFIG_NAME} docker compose run --rm nvim bash"
echo ""
