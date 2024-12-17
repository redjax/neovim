#!/bin/bash

CWD=$(pwd)
echo "[DEBUG] CWD: ${CWD}"

NVIM_CONFIG_SRC="${CWD}/config/nvim"
echo "[DEBUG] Neovim config source: ${NVIM_CONFIG_SRC}"

NVIM_CONFIG_DEST="${HOME}/.config/nvim"
echo "[DEBUG] Neovim config destination: ${NVIM_CONFIG_DEST}"

if [[ -d $NVIM_CONFIG_DEST ]]; then
    echo "Neovim config already exists at $NVIM_CONFIG_DEST"

    if [ -L "${NVIM_CONFIG_DEST}" ]; then
        echo "Neovim path is a symlink. Removing link"
        rm "${NVIM_CONFIG_DEST}"
    else
        echo "Neovim path is not a symlink. Backing up to ${NVIM_CONFIG_DEST}.bak"
        mv "${NVIM_CONFIG_DEST}" "${NVIM_CONFIG_DEST}.bak"
    fi
fi

echo "Creating symlink from ${NVIM_CONFIG_SRC} to ${NVIM_CONFIG_DEST}"
ln -s "${NVIM_CONFIG_SRC}" "${NVIM_CONFIG_DEST}"

if [[ ! $? -eq 0 ]]; then
    echo "Error occurred creating symlink from ${NVIM_CONFIG_SRC} to ${NVIM_CONFIG_DEST}"
    exit 1
fi

if [[ ! -L "${NVIM_CONFIG_DEST}" ]]; then
    echo "Error occurred creating symlink from ${NVIM_CONFIG_SRC} to ${NVIM_CONFIG_DEST}"
    exit 1
fi
