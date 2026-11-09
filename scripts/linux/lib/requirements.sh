#!/usr/bin/env bash

# THE dependency manifest: package names belong only in this function.
# Add a group here, then request it with --with GROUP.
packages_for() {
	local group=$1

	case "$group:$BACKEND" in
	core:brew)
		echo "git curl gnu-tar gzip unzip jq"
		;;

	core:apt-get)
		echo "ca-certificates git curl tar gzip unzip jq build-essential"
		;;

	core:dnf | core:yum)
		echo "ca-certificates git curl tar gzip unzip jq gcc gcc-c++ make"
		;;

	core:pacman)
		echo "ca-certificates git curl tar gzip unzip jq base-devel"
		;;

	build:brew)
		echo "cmake ninja gettext"
		;;

	build:apt-get)
		echo "cmake ninja-build gettext"
		;;

	build:dnf | build:yum)
		echo "cmake ninja-build gettext glibc-gconv-extra"
		;;

	build:pacman)
		echo "cmake ninja gettext"
		;;

	search:brew)
		echo "ripgrep fd"
		;;

	search:apt-get | search:dnf | search:yum)
		echo "ripgrep fd-find"
		;;

	search:pacman)
		echo "ripgrep fd"
		;;

	shell:*)
		echo "shellcheck shfmt"
		;;

	node:brew)
		echo "node"
		;;

	node:*)
		echo "nodejs npm"
		;;

	go:brew | go:pacman)
		echo "go"
		;;

	go:apt-get | go:dnf | go:yum)
		echo "golang"
		;;

	python:brew)
		echo "python"
		;;

	python:apt-get)
		echo "python3 python3-venv python3-pip"
		;;

	python:dnf | python:yum)
		echo "python3 python3-pip"
		;;

	python:pacman)
		echo "python python-pip"
		;;

	powershell:*)
		echo "powershell"
		;;

	rust:brew)
		echo "rust"
		;;

	rust:*)
		echo "rustc cargo"
		;;

	clipboard:brew)
		if [[ $OS == Darwin ]]; then
			return 0
		fi

		echo "wl-clipboard xclip"
		;;

	clipboard:*)
		echo "wl-clipboard xclip"
		;;

	repos:brew)
		[[ $OS == Darwin ]] ||
			errexit "No Homebrew locate group here; use your native package manager."

		return 0
		;;

	repos:apt-get | repos:dnf | repos:yum | repos:pacman)
		echo "plocate"
		;;

	font:brew)
		[[ $OS == Darwin ]] ||
			errexit "Use your Linux font manager, or install FiraCode Nerd Font manually."

		echo "font-fira-code-nerd-font"
		;;

	font:*)
		echo "fontconfig"
		;;

	neovide:*)
		echo "neovide"
		;;

	fzf:*)
		echo "fzf"
		;;

	flatpak:*)
		echo "flatpak"
		;;

	fuse:apt-get)
		if apt-cache show libfuse2t64 >/dev/null 2>&1; then
			echo "libfuse2t64"
		else
			echo "libfuse2"
		fi
		;;

	fuse:dnf | fuse:yum)
		echo "fuse-libs"
		;;

	fuse:pacman)
		echo "fuse2"
		;;

	*)
		errexit "No package mapping for group '$group' with backend '$BACKEND'."
		;;
	esac
}

install_group() {
	local group=$1
	local text

	local -a packages=()

	[[ -n $BACKEND ]] ||
		errexit "No package backend for '$group'; provision its tools manually and use --skip-deps."

	text="$(packages_for "$group")"

	if [[ -n $text ]]; then
		read -r -a packages <<<"$text"

		log "Dependencies: $group ($BACKEND)"
		install_packages "${packages[@]}"
	fi
}

check_core() {
	local command

	[[ $DRY_RUN == 0 ]] || return 0

	for command in git curl tar gzip unzip jq; do
		need "$command"
	done

	if ! has cc && ! has gcc && ! has clang; then
		errexit "A C compiler is required for parser installation. On macOS: xcode-select --install"
	fi
}
