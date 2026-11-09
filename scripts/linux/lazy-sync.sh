#!/usr/bin/env bash

##
# Synchronize Neovim's Lazy plugin manager plugins.
#
# You can run this to update the lazy lockfiles for all your profiles,
# or the first time after installing the Neovim configs in this repo
# to initialize your plugins.
#
# By default, discovers all profiles in config/ that have a lazy-lock.json
# (i.e. profiles that use lazy.nvim). You can override with -p flags.
##

if ! command -v nvim &>/dev/null; then
	echo "Neovim is not installed"
	exit 1
fi

## Discover repo root from script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_DIR="${REPO_ROOT}/config"

## Discover profiles that use lazy.nvim (have a lazy-lock.json)
discover_lazy_profiles() {
	local directory

	for directory in "$CONFIG_DIR"/*/; do
		[[ -d $directory ]] || continue
		[[ -f "$directory/lazy-lock.json" ]] || continue

		directory=${directory%/}
		printf '%s\n' "${directory##*/}"
	done
}

## Discover all valid profiles (for validation)
discover_all_profiles() {
	local directory

	for directory in "$CONFIG_DIR"/*/; do
		[[ -d $directory ]] || continue

		directory=${directory%/}
		printf '%s\n' "${directory##*/}"
	done
}

## Temp array for user-supplied profiles
USER_PROFILES=()

## Parse arguments
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
	-p | --profile)
		if [[ -z ${2:-} || $2 == -* ]]; then
			echo "[ERROR] $1 requires a profile name." >&2
			exit 1
		fi

		USER_PROFILES+=("$2")
		shift 2
		;;
	-h | --help)
		echo "Usage: $0 [-p|--profile <profile>] ..."
		echo ""
		echo "Without -p, syncs all profiles that have a lazy-lock.json in config/."
		echo "Use -p multiple times to specify profiles manually."
		exit 0
		;;
	*)
		echo "[ERROR] Invalid argument provided: $1"
		exit 1
		;;
	esac
done

## Use user profiles if provided, otherwise discover from config/
PROFILES=()

if [[ ${#USER_PROFILES[@]} -gt 0 ]]; then
	ALL_PROFILES=()

	while IFS= read -r profile; do
		ALL_PROFILES+=("$profile")
	done < <(discover_all_profiles)

	for requested_profile in "${USER_PROFILES[@]}"; do
		found=0

		for available_profile in "${ALL_PROFILES[@]}"; do
			if [[ $requested_profile == "$available_profile" ]]; then
				found=1
				break
			fi
		done

		if [[ $found -eq 1 ]]; then
			PROFILES+=("$requested_profile")
		else
			echo "[WARNING] Profile '$requested_profile' not found in ${CONFIG_DIR}, skipping."
		fi
	done
else
	while IFS= read -r profile; do
		PROFILES+=("$profile")
	done < <(discover_lazy_profiles)
fi

if [[ ${#PROFILES[@]} -eq 0 ]]; then
	echo "No profiles to sync."
	exit 0
fi

echo "Using profiles: ${PROFILES[*]}"

## Iterate over profiles
for profile in "${PROFILES[@]}"; do
	echo "Processing profile: $profile"

	## Export NVIM_APPNAME for this profile
	export NVIM_APPNAME="$profile"

	## Run nvim headless with lazy operations
	nvim --headless '+Lazy! sync' '+Lazy! clean' '+Lazy! update' +qa

	if [[ $? -ne 0 ]]; then
		echo "Failed to update lockfiles for $profile"
		continue
	fi

	sleep 2
done

unset NVIM_APPNAME

echo "Updated lockfiles for ${#PROFILES[@]} profile(s)."
