#!/bin/bash

CWD=$(pwd)
DEBUG=${DEBUG:-0}

if [[ $DEBUG -eq 1 ]]; then
  echo "[DEBUG] CWD: ${CWD}"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOTCONFIG_DIR="${HOME}/.config"

if [[ $DEBUG -eq 1 ]]; then
  echo "[DEBUG] Config directory: ${DOTCONFIG_DIR}"
fi

NVIM_CONFIGS=()

if [[ ! -d "config/" ]]; then
  echo "[ERROR] Could not find directory 'config/' at path: ${CWD}"
  exit 1
fi

echo "Getting configurations from path: config/"
for _conf in config/*; do
  if [ -d "$_conf" ]; then
    if [[ $DEBUG -eq 1 ]]; then
      echo "[DEBUG] Adding config: $_conf"
    fi
    NVIM_CONFIGS+=("${_conf##*/}")
  fi
done

echo "Found [${#NVIM_CONFIGS[@]}] configurations"

for conf in "${NVIM_CONFIGS[@]}"; do
  ## Check if directory exists
  if [[ ! -d "$HOME/.config/$conf" ]]; then
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] Creating symlink for config: $conf at path: $HOME/.config/$conf"
    fi

    ## Create symlink
    # ln -s "$SCRIPT_DIR/config/$conf" "$DOTCONFIG_DIR/$conf"
    # if [[ ! $? -eq 0 ]]; then
    #   echo "[ERROR] Could not create symlink for config: $conf to path: $HOME/.config/$conf"
    #   continue
    # fi

  elif [[ -L "$HOME/.config/$conf" ]]; then
    echo "Path is already a symlink: $HOME/.config/$conf"
    continue
  fi
done
