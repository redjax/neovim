#!/usr/bin/env bash

## Names are passed as ordinary arguments, not array variable names.
discover_profiles() {
	local directory

	[[ -d $CONFIG_SOURCE ]] ||
		errexit "Config source directory not found: $CONFIG_SOURCE"

	for directory in "$CONFIG_SOURCE"/*; do
		[[ -d $directory ]] || continue

		printf '%s\n' "${directory##*/}"
	done
}

link_configs() {
	local target_root=$1
	local backup_configs=${2:-0}
	local dry_run=${3:-0}

	local profile
	local source
	local target
	local count=0
	local stamp

	## Keep command execution local to this operation.
	(
		## Names are unique to this subshell and do not replace common.sh's run().
		link_run() {
			if [[ $dry_run == 1 ]]; then
				printf '[DRY RUN]' >&2
				printf ' %q' "$@" >&2
				printf '\n' >&2
			else
				"$@"
			fi
		}

		link_run mkdir -p -- "$target_root"

		while IFS= read -r profile; do
			[[ -n $profile ]] || continue

			count=$((count + 1))

			source="$(
				cd -- "$CONFIG_SOURCE/$profile" &&
					pwd -P
			)"

			target="$target_root/$profile"

			if [[ -L $target && $(readlink "$target") == "$source" ]]; then
				log "Already linked: $target"
				continue
			fi

			if [[ -e $target || -L $target ]]; then
				if [[ $backup_configs == 1 ]]; then
					stamp="$(date +%Y%m%d-%H%M%S).$$"

					link_run mv -- "$target" "$target.backup.$stamp"
				else
					warn "Preserving existing path: $target (use --backup-configs to move it aside)"
					continue
				fi
			fi

			link_run ln -s -- "$source" "$target"
		done < <(discover_profiles)

		[[ $count -gt 0 ]] ||
			die "No profiles found in $CONFIG_SOURCE"
	)
}
