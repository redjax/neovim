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
AUTO_YES=0

PROFILE="nvim"
FLATPAK=0

usage() {
	cat <<'EOF'
Usage: clean_config_plugins.sh [OPTIONS]

Deletes profile data directories, not repository configuration files.

Options:
  -p, --profile NAME      Profile to clean, or "all" (default: nvim)
  --yes                   Do not prompt before deletion
  --dry-run               Describe deletions without making them
  --flatpak               Clean Flatpak profile data
  --config-source DIR     Override the repository profile directory
  -h, --help              Show this help

Warning:
  This removes the entire profile data directory, not just plugins.
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	-p | --profile)
		require_value "$@"
		PROFILE=$2
		shift 2
		;;

	--yes)
		AUTO_YES=1
		shift
		;;

	--dry-run)
		DRY_RUN=1
		shift
		;;

	--flatpak)
		FLATPAK=1
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

PROFILES=()

while IFS= read -r name; do
	[[ -z $name ]] || PROFILES+=("$name")
done < <(discover_profiles)

[[ ${#PROFILES[@]} -gt 0 ]] ||
	errexit "No profiles found."

if [[ $PROFILE != all ]]; then
	found=0

	for name in "${PROFILES[@]}"; do
		[[ $name != "$PROFILE" ]] || found=1
	done

	[[ $found == 1 ]] ||
		errexit "Unknown profile: $PROFILE"

	PROFILES=("$PROFILE")
fi

if [[ $FLATPAK == 1 ]]; then
	DATA_HOME="$HOME/.var/app/io.neovim.nvim/data"
fi

[[ $DATA_HOME == /* &&
	$DATA_HOME != / &&
	$DATA_HOME != "$HOME" ]] ||
	errexit "Unsafe data root."

for name in "${PROFILES[@]}"; do
	[[ $name != . &&
		$name != .. &&
		$name != */* ]] ||
		errexit "Unsafe profile name."

	target="$DATA_HOME/$name"

	if [[ ! -e $target && ! -L $target ]]; then
		log "Not present: $target"
		continue
	fi

	if [[ $DRY_RUN == 0 && $AUTO_YES == 0 ]]; then
		printf \
			"Delete profile data '%s'? This includes more than plugins. [y/N] " \
			"$target" >&2

		read -r answer || exit 1

		case "$answer" in
		y | Y | yes | YES) ;;

		*)
			log "Skipped: $name"
			continue
			;;
		esac
	fi

	run rm -rf -- "$target"
done

log "Done. Config files were not deleted."
log "Reopen the profile to bootstrap plugins."
