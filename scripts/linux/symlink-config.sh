#!/bin/bash

set -e

CWD=$(pwd)
DEBUG=${DEBUG:-0}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTCONFIG_DIR="${HOME}/.config"

if [[ $DEBUG -eq 1 ]]; then
  echo "[DEBUG] Script directory: ${SCRIPT_DIR}"
  echo "[DEBUG] CWD: ${CWD}"
  echo "[DEBUG] Config directory: ${DOTCONFIG_DIR}"
fi

## Array to store discovered configs in repository
NVIM_CONFIGS=()

if [[ ! -d "config/" ]]; then
  echo "[ERROR] Could not find directory 'config/' at path: ${CWD}"
  exit 1
fi

## Iterate over config directory & load discovered config dirs into NVIM_CONFIGS
echo "Getting configurations from path: config/"
for _conf in config/*; do
  if [ -d "$_conf" ]; then
    if [[ $DEBUG -eq 1 ]]; then
      echo "[DEBUG] Adding config: $_conf"
    fi
    NVIM_CONFIGS+=("${_conf##*/}")
  fi
done

echo "Found [${#NVIM_CONFIGS[@]}] configurations:"
for c in "${NVIM_CONFIGS[@]}"; do
  echo "  - $c"
done

## Symlink discovered configurations
for conf in "${NVIM_CONFIGS[@]}"; do
  ## Get absolute path to config file
  abs_path="$(cd "./config/$conf" && pwd)"
  
  if [[ $DEBUG -eq 1 ]]; then
    echo "[DEBUG] Config absolute path: $abs_path"
  fi

  ## Check if directory exists
  if [[ -d "$DOTCONFIG_DIR/$conf" ]]; then
    echo "Neovim config already exists at $DOTCONFIG_DIR/$conf"
    continue
  elif [ -L "$DOTCONFIG_DIR/$conf" ]; then
    echo "Path is already a symlink: $DOTCONFIG_DIR/$conf"
    continue
  else

    echo "Creating symlink: $abs_path --> $DOTCONFIG_DIR/$conf"
    
    ## Create symlink
    ln -s "${abs_path}" "$DOTCONFIG_DIR/$conf"
    if [[ ! $? -eq 0 ]]; then
      echo "[ERROR] Could not create symlink for config: $conf to path: $DOTCONFIG_DIR/$conf"
      continue
    fi
  fi
done

echo ""
echo "Finished linking Neovim configurations."
echo ""
echo "To launch a specific config, use:"
echo "  NVIM_APPNAME=\$nvim_conf nvim"
echo "  i.e. NVIM_APPNAME=nvim-noplugins nvim"
echo ""
