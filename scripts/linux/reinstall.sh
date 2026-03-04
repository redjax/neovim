#!/usr/bin/env bash

set -uo pipefail

## Path where this script is
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
## Path to root of Architecture repository from the script's path
REPO_ROOT=$(realpath -m "$THIS_DIR/../../")

SCRIPTS_DIR="${REPO_ROOT}/scripts/linux"

function print_warning() {
  echo ""
  echo "[ WARNING ]"
  echo " ---------"
  echo "This script completely uninstalls & reinstalls the Neovim configuration."
  echo "  It does not remove installed dependencies, but will re-run the script &"
  echo "  may update/overwrite existing packages."
  echo ""
  echo "The script also unlinks all the configuration directories, and uninstalls"
  echo "  all Neovim plugins."
  echo ""
}

function usage() {
  echo ""
  echo "Usage: ${0} [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --dry-run  Instead of taking actions, describe what would happen."
  echo "  -h|--help  Print this help menu"
  echo ""
}

## Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
  --dry-run)
    DRY_RUN=true

    echo "-- Dry Run Enabled"
    shift
    ;;
  -h | --help)
    usage

    exit 0
    ;;
  *)
    echo "[ERROR] Invalid argument: $1"
    usage
    exit 1
    ;;
  esac
done
## Confirm user wants to proceed with operation
print_warning

while true; do
  read -r -n 1 -p "Do you want to reinstall Neovim? (y/n): " _proceed
  echo ""

  case $_proceed in
  [Yy])
    echo "Proceeding with reinstall."
    break
    ;;
  [Nn])
    echo "Exiting."
    exit 0
    ;;
  *)
    echo "[WARNING] Invalid answer: $_proceed. Please use 'y' or 'n'."
    ;;
  esac
done

_cmds=(
  "${SCRIPTS_DIR}/clean_config_plugins.sh"
  "${SCRIPTS_DIR}/install.sh"
  "${SCRIPTS_DIR}/install-lsp-requirements.sh"
  "${SCRIPTS_DIR}/lazy-sync.sh"
)

## Validate all scripts exist and are executable
echo ""
echo "Validating required scripts..."
for cmd in "${_cmds[@]}"; do
  if [[ ! -f "$cmd" ]]; then
    echo "[ERROR] Script does not exist: $cmd"
    exit 1
  fi
  
  if [[ ! -x "$cmd" ]]; then
    echo "[ERROR] Script is not executable: $cmd"
    echo "  Run: chmod +x $cmd"
    exit 1
  fi
  
  echo "  $cmd"
done
echo ""

for cmd in "${_cmds[@]}"; do
  echo "Command: $cmd"
  
  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    echo "[DRY RUN] Would execute: $cmd"
    continue
  fi

  "$cmd"
  if [[ $? -ne 0 ]]; then
    echo ""
    echo "[ERROR] Failed running command: ${cmd}."
    echo ""

    exit 1
  fi
done
