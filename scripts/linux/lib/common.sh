#!/usr/bin/env bash

log() {
	printf '[INFO] %s\n' "$*" >&2
}

warn() {
	printf '[WARNING] %s\n' "$*" >&2
}

errexit() {
	printf '[ERROR] %s\n' "$*" >&2
	exit 1
}

has() {
	command -v "$1" >/dev/null 2>&1
}

need() {
	has "$1" || errexit "Required command not found: $1"
}

run() {
	if [[ ${DRY_RUN:-0} == 1 ]]; then
		printf '[DRY RUN]' >&2
		printf ' %q' "$@" >&2
		printf '\n' >&2
	else
		"$@"
	fi
}

as_root() {
	if [[ $EUID == 0 ]]; then
		run "$@"
	else
		need sudo
		run sudo "$@"
	fi
}

require_value() {
	[[ -n ${2:-} && $2 != --* ]] ||
		errexit "$1 requires a value"
}

## Resolve paths from this file, never from the caller's working directory.
LIB_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

SCRIPTS_DIR="$(
	cd -- "$LIB_DIR/.." &&
		pwd -P
)"

REPO_ROOT="$(
	cd -- "$SCRIPTS_DIR/../.." &&
		pwd -P
)"

CONFIG_SOURCE="${CONFIG_SOURCE:-$REPO_ROOT/config}"
## Shared setting consumed by scripts that source this library.
# shellcheck disable=SC2034
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
## Shared setting consumed by scripts that source this library.
# shellcheck disable=SC2034
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
BUILD_DIR="${BUILD_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/neovim-installer}"
PREFIX="${PREFIX:-$HOME/.local/opt/neovim}"

## Shared setting consumed by scripts that source this library.
# shellcheck disable=SC2034
OS="$(uname -s)"
## Shared setting consumed by scripts that source this library.
# shellcheck disable=SC2034
ARCH="$(uname -m)"

## Native package backends supported by this installer.
NATIVE_PM=""

for candidate in apt-get dnf yum pacman; do
	if has "$candidate"; then
		NATIVE_PM="$candidate"
		break
	fi
done

## Prefer Homebrew for dependency installation when available.
BACKEND="$NATIVE_PM"

if has brew; then
	BACKEND="brew"
fi

APT_READY=0

refresh_packages() {
	if [[ $BACKEND == apt-get && $APT_READY == 0 ]]; then
		as_root apt-get update
		APT_READY=1
	fi
}

install_packages() {
	[[ $# -gt 0 ]] || return 0

	case "$BACKEND" in
	brew)
		run brew install "$@"
		;;

	apt-get)
		refresh_packages
		as_root apt-get install -y "$@"
		;;

	dnf | yum)
		as_root "$BACKEND" install -y "$@"
		;;

	pacman)
		as_root pacman -S --needed --noconfirm "$@"
		;;

	*)
		errexit "No supported package backend; install the listed tools manually."
		;;
	esac
}

package_available() {
	case "$BACKEND" in
	brew)
		brew info --formula "$1" >/dev/null 2>&1
		;;

	apt-get)
		apt-cache policy "$1" |
			awk '
          /Candidate:/ {
            if ($2 != "(none)") {
              ok = 1
            }
          }

          END {
            exit !ok
          }
        '
		;;

	dnf | yum)
		"$BACKEND" -q list --available "$1" >/dev/null 2>&1 ||
			"$BACKEND" -q list --installed "$1" >/dev/null 2>&1
		;;

	pacman)
		pacman -Si "$1" >/dev/null 2>&1
		;;

	*)
		return 1
		;;
	esac
}
