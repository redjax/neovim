#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

. "${LIB_DIR}/path.sh"
. "${LIB_DIR}/config.sh"

CWD=$(pwd)
DEBUG=${DEBUG:-0}
DOTCONFIG_DIR="${HOME}/.config"

if [[ $DEBUG -eq 1 ]]; then
  echo "[DEBUG] Script directory: ${SCRIPT_DIR}"
  echo "[DEBUG] CWD: ${CWD}"
  echo "[DEBUG] Config directory: ${DOTCONFIG_DIR}"
fi

if [[ ! -d "${CWD}/config" ]]; then
  echo "[ERROR] Could not find directory 'config/' at path: ${CWD}"
  exit 1
fi

REPO_CONFIGS=($(detect_repo_configs))

echo "Found [${#REPO_CONFIGS[@]}] configurations:"
for c in "${REPO_CONFIGS[@]}"; do
  echo "  - $c"
done

symlink-config REPO_CONFIGS

echo ""
echo "Finished linking Neovim configurations."
echo ""
echo "To launch a specific config, use:"
echo "  NVIM_APPNAME=\$nvim_conf nvim"
echo "  i.e. NVIM_APPNAME=nvim-noplugins nvim"
echo ""
