#!/bin/bash

## Discover valid profiles dynamically from config/ directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_DIR="${REPO_ROOT}/config"

VALID_PROFILES=()
if [[ -d "$CONFIG_DIR" ]]; then
  for d in "$CONFIG_DIR"/*/; do
    [[ -d "$d" ]] && VALID_PROFILES+=("$(basename "$d")")
  done
fi

if [[ ${#VALID_PROFILES[@]} -eq 0 ]]; then
  echo "Error: no profiles found in ${CONFIG_DIR}" >&2
  exit 1
fi

DEFAULT_PROFILE="nvim"

usage() {
  cat <<EOF
Usage: $0 [-p|--profile <profile>|all] [--yes]
Cleans out the Neovim profile plugin directories under ~/.local/share.

Profiles are discovered from: ${CONFIG_DIR}

Options:
  -p, --profile   Profile name to clean. One of: ${VALID_PROFILES[*]}, or "all". Default: ${DEFAULT_PROFILE}
  --yes          Don't prompt before deletion.
  -h, --help     Show this help message.

Examples:
  $0                       # cleans default profile "nvim" -> ~/.local/share/nvim
  $0 -p nvim-noplugins        # cleans ~/.local/share/nvim-noplugins
  $0 --profile all --yes   # force delete all profile dirs without prompt
EOF
}

## Return the target directory for a given profile
get_target_dir() {
  local profile=$1
  echo "$HOME/.local/share/${profile}"
}

## parse args
PROFILE="${DEFAULT_PROFILE}"
AUTO_YES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--profile)
      if [[ -n "${2-}" ]]; then
        PROFILE="$2"
        shift 2
      else
        echo "Error: --profile requires an argument" >&2
        usage
        exit 1
      fi
      ;;
    --yes)
      AUTO_YES=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

## build list of targets
to_delete=()

if [[ "$PROFILE" == "all" ]]; then
  for p in "${VALID_PROFILES[@]}"; do
    to_delete+=("$(get_target_dir "$p")")
  done

else
  found=0
  ## validate
  for p in "${VALID_PROFILES[@]}"; do
    if [[ "$p" == "$PROFILE" ]]; then
      found=1
      break
    fi
  done

  if [[ $found -ne 1 ]]; then
    echo "Error: invalid profile '$PROFILE'. Valid: ${VALID_PROFILES[*]}, or all." >&2
    exit 1
  fi
  
  ## Append dir to to_delete arr
  to_delete+=("$(get_target_dir "$PROFILE")")

fi

## Confirm and delete
for dir in "${to_delete[@]}"; do
  if [[ ! -e "$dir" ]]; then
    echo "Skipping: $dir does not exist."
    continue
  fi

  if [[ $AUTO_YES -eq 0 ]]; then
    read -rp "About to remove $dir (requires sudo). Continue? [y/N] " ans

    case "$ans" in
      [Yy]*) ;;
      *) echo "Skipped $dir"; continue ;;
    esac
  fi

  echo "Removing $dir ..."
  
  sudo rm -rf -- "$dir"
  if [[ $? -ne 0 ]]; then
    echo "Failed to remove $dir"
  else
    echo "Removed $dir"
  fi
done

echo "Done. If deletion was successful, you should open neovim and run :Lazy clean, then :Lazy sync (or press S when Lazy loads for the clean operation)."
