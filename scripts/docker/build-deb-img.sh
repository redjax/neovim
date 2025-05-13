#!/bin/bash

PLAIN_DOCKER_BUILD_OUTPUT=${PLAIN_DOCKER_BUILD_OUTPUT:-1}

CWD=$(pwd)
CONTAINER_DIR="${CWD}/containers"
DOCKERFILE="${CONTAINER_DIR}/deb.Dockerfile"
CONTAINER_NAME="neovim"
CONTAINER_IMG_TAG="nvim-buildtest"

if ! command -v docker > /dev/null 2>&1; then
    echo "[WARNING] docker is not installed."
    exit 1
else
    echo "docker is installed, continuing."
fi

if ! docker compose version > /dev/null 2>&1; then
    echo "[WARNING] docker compose is not installed."
    exit 1
else
    echo "docker compose is installed, continuing."
fi

## Check if Dockerfile exists
if [[ ! -f "${DOCKERFILE}" ]]; then
    echo "[ERROR] Dockerfile not found at path: ${DOCKERFILE}"
    exit 1
else
    echo "Dockerfile found at path: ${DOCKERFILE}"
fi

## Build the Docker image
echo "Building container from Dockerfile: ${DOCKERFILE}, tagging with: ${CONTAINER_IMG_TAG}"

if [[ $PLAIN_DOCKER_BUILD_OUTPUT -eq 1 || "${PLAIN_DOCKER_BUILD_OUTPUT}" == "1" ]] ; then
    CONTAINER_ENV=1 NEOVIM_MAKE_BUILD_DIR="/tmp/build" docker build -f "${DOCKERFILE}" -t "${CONTAINER_IMG_TAG}" . --progress=plain
else
    docker build -f "${DOCKERFILE}" -t "${CONTAINER_IMG_TAG}" . 
fi

if [[ ! $? -eq 0 ]]; then
    echo "[ERROR] Failed to build Dockerfile at path: ${DOCKERFILE}"
    exit $?
else
    echo "[SUCCESS] Dockerfile at path '${DOCKERFILE}' built successfully. Tagged container as: ${CONTAINER_IMG_TAG}"
    exit 0
fi
