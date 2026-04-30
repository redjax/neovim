#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

. "${LIB_DIR}/path.sh"
. "${LIB_DIR}/config.sh"

CONFIG_DIR="${REPO_ROOT}/config"
DEFAULT_PROFILE="nvim"
PROFILE="${DEFAULT_PROFILE}"
AUTO_YES=0

VALID_PROFILES=()
if ! discover_profile_names "$CONFIG_DIR" VALID_PROFILES; then
  echo "Error: no profiles found in ${CONFIG_DIR}" >&2
  exit 1
fi

usage() {
  cat <<EOF
Usage: $0 [-p|--profile <profile>|all] [--yes]
Cleans profile data directories under ~/.local/share (not repo config files).

Profiles are discovered from: ${CONFIG_DIR}

Options:
  -p, --profile   Profile name to clean. One of: ${VALID_PROFILES[*]}, or "all". Default: ${DEFAULT_PROFILE}
  --yes           Do not prompt before deletion.
  -h, --help      Show this help message.

Examples:
  $0                          # cleans default profile "nvim" -> ~/.local/share/nvim
  $0 -p nvim-noplugins        # cleans ~/.local/share/nvim-noplugins
  $0 -p nvim12                # cleans ~/.local/share/nvim12 and ~/.local/share/nvim12/vim.pack
  $0 --profile all --yes      # force delete all profile data dirs without prompt
EOF
}

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

ALL_TARGETS=()

if [[ "$PROFILE" == "all" ]]; then
  for p in "${VALID_PROFILES[@]}"; do
    PROFILE_TARGETS=()
    profile_data_cleanup_targets "$p" PROFILE_TARGETS
    ALL_TARGETS+=("${PROFILE_TARGETS[@]}")
  done
else
  if ! profile_is_valid "$PROFILE" VALID_PROFILES; then
    echo "Error: invalid profile '$PROFILE'. Valid: ${VALID_PROFILES[*]}, or all." >&2
    exit 1
  fi

  profile_data_cleanup_targets "$PROFILE" ALL_TARGETS
fi

remove_targets_with_prompt ALL_TARGETS "$AUTO_YES"

echo "Done. If deletion was successful, open Neovim and run :Lazy clean, then :Lazy sync."
