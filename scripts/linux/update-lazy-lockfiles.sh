#!/usr/bin/env bash

if ! command -v nvim &>/dev/null; then
    echo "Neovim is not installed"
    exit 1
fi

## Default profiles array
PROFILES=("nvim" "nvim-work")

## Temp array for user-supplied profiles
PROVIDED_PROFILES=()

## Parse arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -p|--profile)
      USER_PROFILES+=("$2")
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [-p|--profile <profile>|all] [--yes]"
      exit 0
      ;;
    *)
      echo "[ERROR] Invalid argument provided: $1"
      exit 1
      ;;
  esac
done

## Use user profiles if provided, otherwise use default
if [ ${#USER_PROFILES[@]} -gt 0 ]; then
  PROFILES=("${USER_PROFILES[@]}")
fi

echo "Using profiles: ${PROFILES[*]}"

## Iterate over profiles
for profile in "${PROFILES[@]}"; do
  echo "Processing profile: $profile"

  ## Export NVIM_APPNAME for this profile
  export NVIM_APPNAME="$profile"

  ## Run nvim headless with lazy operations
  nvim --headless -c "Lazy sync" -c "Lazy clean" -c "qa"

  if [[ $? -ne 0 ]]; then
    echo "Failed to update lockfiles for $profile"
    continue
  fi

  sleep 2
done

unset NVIM_APPNAME

echo "Updated lockfiles for ${#PROFILES[@]} profile(s)."
