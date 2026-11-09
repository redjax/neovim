#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

# shellcheck source=lib/config.sh
. "$SCRIPT_DIR/lib/config.sh"

DRY_RUN=0
BACKUP_CONFIGS=0

TARGET="$CONFIG_HOME"

usage() {
	cat <<'EOF'
Usage: symlink-config.sh [OPTIONS]

Options:
  --dry-run              Describe changes without making them
  --backup-configs       Move conflicting paths aside before linking
  --flatpak              Link into Flatpak's configuration directory
  --config-source DIR    Override the repository profile directory
  -h, --help             Show this help
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--dry-run)
		DRY_RUN=1
		shift
		;;

	--backup-configs)
		BACKUP_CONFIGS=1
		shift
		;;

	--flatpak)
		TARGET="$HOME/.var/app/io.neovim.nvim/config"
		shift
		;;

	--config-source)
		require_value "$@"
		CONFIG_SOURCE=$2
		shift 2
		;;

	-h | --help)
		usage
		exit 0
		;;

	*)
		errexit "Unknown option: $1"
		;;
	esac
done

[[ -d $CONFIG_SOURCE ]] ||
	errexit "Config source not found: $CONFIG_SOURCE"

link_configs "$TARGET" "$BACKUP_CONFIGS" "$DRY_RUN"

log "Finished linking configurations."
log "Example: NVIM_APPNAME=nvim-noplugins nvim"
