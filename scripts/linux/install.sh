#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

# shellcheck source=lib/requirements.sh
. "$SCRIPT_DIR/lib/requirements.sh"

# shellcheck source=lib/config.sh
. "$SCRIPT_DIR/lib/config.sh"

# shellcheck source=lib/installers.sh
. "$SCRIPT_DIR/lib/installers.sh"

METHOD="auto"
REF="stable"

DRY_RUN=0
SKIP_DEPS=0
DEPS_ONLY=0

LINK_CONFIGS=1
BACKUP_CONFIGS=0

MIN_NVIM="${MIN_NVIM:-0.12.0}"

WITH=()

usage() {
	cat <<'EOF'
Usage: install.sh [OPTIONS]

Default: Homebrew -> supported native package repository -> source.
Installs core tools, Tree-sitter CLI, Neovim, and links config profiles.

Options:
  --from-source           Force a source build
  --flatpak               Force Flatpak (Linux)
  --appimage, --appimg    Force AppImage (Linux)

  --ref REF               Git tag/branch for source builds (default: stable)
  --build-dir DIR         Temporary source-build parent directory
  --prefix DIR            Source installation prefix. Default: ~/.local/opt/neovim

  --with GROUP            Add optional dependencies. Can be passed multiple times
  --deps-only             Install dependencies, but not Neovim or config links
  --skip-deps             Do not install dependencies or Tree-sitter CLI

  --no-symlink            Do not link configuration profiles
  --backup-configs        Move conflicting config paths aside before linking
  --config-source DIR     Repository profile directory

  --dry-run               Print changes without making them
  --debug, -D             Enable Bash tracing
  -h, --help              Show help

Dependency groups (--with <group>):
  search
  shell
  node
  go
  python
  powershell
  rust
  clipboard
  repos
  font
  neovide
  fzf
  uv
  fuse

Environment:
  MIN_NVIM
  TREE_SITTER_RELEASE
  NVIM_RELEASE
  GITHUB_TOKEN
  BIN_DIR
  CONFIG_SOURCE
  BUILD_DIR
  PREFIX
  XDG_CONFIG_HOME
  XDG_DATA_HOME
  XDG_CACHE_HOME

Package availability depends on configured repositories.

No repositories are added automatically, except user Flathub when
--flatpak is explicitly requested.
EOF
}

select_method() {
	[[ $METHOD == auto ]] ||
		errexit "Choose only one installation-method override."

	METHOD=$1
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--from-source)
		select_method source
		shift
		;;

	--flatpak)
		select_method flatpak
		shift
		;;

	--appimage | --appimg)
		select_method appimage
		shift
		;;

	--ref)
		require_value "$@"
		REF=$2
		shift 2
		;;

	--build-dir)
		require_value "$@"
		BUILD_DIR=$2
		shift 2
		;;

	--prefix)
		require_value "$@"
		PREFIX=$2
		shift 2
		;;

	--config-source)
		require_value "$@"
		CONFIG_SOURCE=$2
		shift 2
		;;

	--with)
		require_value "$@"

		case "$2" in
		search | shell | node | go | python | powershell | rust | \
			clipboard | repos | font | neovide | fzf | uv | fuse)
			WITH+=("$2")
			;;

		*)
			errexit "Unknown dependency group: $2"
			;;
		esac

		shift 2
		;;

	--deps-only)
		DEPS_ONLY=1
		LINK_CONFIGS=0
		shift
		;;

	--skip-deps)
		SKIP_DEPS=1
		shift
		;;

	--no-symlink)
		LINK_CONFIGS=0
		shift
		;;

	--backup-configs)
		BACKUP_CONFIGS=1
		shift
		;;

	--dry-run)
		DRY_RUN=1
		shift
		;;

	--debug | -D)
		set -x
		shift
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

printf '[DEBUG] script=%q OS=%q uname=%q\n' \
	"${BASH_SOURCE[0]}" \
	"${OS-UNSET}" \
	"$(uname -s)" >&2

[[ $OS == Linux || $OS == Darwin ]] ||
	die "This installer supports Linux and macOS; Windows needs a separate installer."

[[ $OS == Linux || $OS == Darwin ]] ||
	errexit "This installer supports Linux and macOS; Windows needs a separate installer."

[[ $PREFIX == /* &&
	$BUILD_DIR == /* &&
	$BIN_DIR == /* ]] ||
	errexit "Use absolute prefix, build, and binary paths."

[[ $SKIP_DEPS == 0 || ${#WITH[@]} == 0 ]] ||
	errexit "--skip-deps cannot be combined with --with."

if [[ $LINK_CONFIGS == 1 && $DEPS_ONLY == 0 ]]; then
	[[ -d $CONFIG_SOURCE ]] ||
		errexit "Config source not found: $CONFIG_SOURCE"
fi

export PATH="$BIN_DIR:$PATH"

log "Platform: $OS / $ARCH; dependency backend: ${BACKEND:-none}"

# Install the shared requirements before selecting/installing Neovim.
if [[ $SKIP_DEPS == 0 ]]; then
	if [[ -n $BACKEND ]]; then
		install_group core
	fi

	check_core
	install_tree_sitter

	for group in "${WITH[@]}"; do
		if [[ $group == font ]]; then
			install_font
		else
			install_group "$group"
		fi
	done
fi

if [[ $DEPS_ONLY == 1 ]]; then
	log "Dependency installation complete."
	exit 0
fi

# Automatic selection is based on available tools and repositories.
if [[ $METHOD == auto ]]; then
	if has brew; then
		METHOD="brew"
	elif [[ -n $NATIVE_PM ]]; then
		BACKEND="$NATIVE_PM"

		refresh_packages

		if [[ $DRY_RUN == 1 ]]; then
			log "Dry run: testing package availability against current local metadata."
		fi

		if package_available neovim; then
			METHOD="package"
		else
			METHOD="source"
		fi
	else
		METHOD="source"
	fi
fi

log "Neovim installation method: $METHOD"

NVIM_CHECK=""

case "$METHOD" in
brew)
	run brew install neovim

	if [[ $DRY_RUN == 0 ]]; then
		NVIM_CHECK="$(brew --prefix neovim)/bin/nvim"
	fi
	;;

package)
	install_packages neovim
	hash -r

	NVIM_CHECK="$(command -v nvim || true)"
	;;

source)
	install_source "${REF}"
	NVIM_CHECK="$BIN_DIR/nvim"
	;;

appimage)
	install_appimage
	NVIM_CHECK="$BIN_DIR/nvim"
	;;

flatpak)
	install_flatpak
	;;
esac

# Verify the installed version before linking configurations.
if [[ $DRY_RUN == 0 ]]; then
	if [[ $METHOD == flatpak ]]; then
		VERSION="$(
			flatpak run io.neovim.nvim --version |
				head -n 1
		)"
	else
		[[ -n $NVIM_CHECK ]] ||
			errexit "Installation returned without a usable nvim executable."

		VERSION="$(
			"$NVIM_CHECK" --version |
				head -n 1
		)"
	fi

	VERSION=${VERSION#NVIM v}

	version_at_least "$VERSION" "$MIN_NVIM" ||
		errexit "Installed Neovim $VERSION is below $MIN_NVIM. Use --from-source --ref <suitable-tag-or-branch>; no implicit method switch was made."

	log "Verified Neovim: $VERSION"
fi

## Flatpak uses a separate configuration root.
if [[ $LINK_CONFIGS == 1 ]]; then
	if [[ $METHOD == flatpak ]]; then
		link_configs \
			"$HOME/.var/app/io.neovim.nvim/config" \
			"$BACKUP_CONFIGS" \
			"$DRY_RUN"
	else
		link_configs \
			"$CONFIG_HOME" \
			"$BACKUP_CONFIGS" \
			"$DRY_RUN"
	fi
fi

log "Finished."

if [[ $METHOD == flatpak ]]; then
	log "Launch: flatpak run --env=NVIM_APPNAME=nvim-noplugins io.neovim.nvim"

	warn "Flatpak tools and permissions are sandboxed; host runtimes may not be visible."
else
	log "Launch: NVIM_APPNAME=nvim-noplugins nvim"

	log "For user installs, ensure $BIN_DIR is on your shell PATH. No shell files were changed."

	if [[ $DRY_RUN == 0 ]]; then
		log "This shell resolves nvim to: $(command -v nvim || true)"
		log "Installation checked using: $NVIM_CHECK"

		[[ $(command -v nvim || true) == "$NVIM_CHECK" ]] ||
			warn "Another installation may shadow the selected installation. Check: type -a nvim"
	fi
fi
