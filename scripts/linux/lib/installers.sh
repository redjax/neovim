#!/usr/bin/env bash

## Download exactly one asset and verify its GitHub-published SHA-256 digest.
release_asset() (
	set -eo pipefail

	local repository=$1
	local release=$2
	local pattern=$3
	local destination=$4

	local tmp
	local endpoint
	local url
	local digest
	local actual
	local count

	local -a headers=(
		-H "Accept: application/vnd.github+json"
	)

	tmp="$(mktemp -d)"
	trap 'rm -rf -- "$tmp"' EXIT

	if [[ -n ${GITHUB_TOKEN:-} ]]; then
		headers+=(
			-H "Authorization: Bearer $GITHUB_TOKEN"
		)
	fi

	endpoint="https://api.github.com/repos/$repository/releases"

	if [[ $release == latest ]]; then
		endpoint+="/latest"
	else
		endpoint+="/tags/$release"
	fi

	curl -fLsS --retry 3 \
		"${headers[@]}" \
		"$endpoint" \
		-o "$tmp/release.json"

	count="$(
		jq --arg p "$pattern" \
			'[.assets[] | select(.name | test($p))] | length' \
			"$tmp/release.json"
	)"

	[[ $count == 1 ]] ||
		errexit "Expected one asset matching '$pattern'; found $count ($repository)."

	url="$(
		jq -er --arg p "$pattern" \
			'.assets[] |
       select(.name | test($p)) |
       .browser_download_url' \
			"$tmp/release.json"
	)"

	digest="$(
		jq -er --arg p "$pattern" \
			'.assets[] |
       select(.name | test($p)) |
       .digest |
       select(type == "string")' \
			"$tmp/release.json"
	)"

	[[ $digest =~ ^sha256:[a-fA-F0-9]{64}$ ]] ||
		errexit "No usable SHA-256 digest in release metadata."

	curl -fLsS --retry 3 \
		"$url" \
		-o "$tmp/asset"

	if has sha256sum; then
		actual="$(sha256sum "$tmp/asset")"
	else
		need shasum
		actual="$(shasum -a 256 "$tmp/asset")"
	fi

	actual=${actual%% *}

	[[ $actual == "${digest#sha256:}" ]] ||
		errexit "Downloaded asset failed SHA-256 verification."

	cp -- "$tmp/asset" "$destination"
)

version_at_least() {
	local have=${1#v}
	local want=${2#v}

	local a b c
	local x y z

	have=${have%%-*}
	want=${want%%-*}

	IFS=. read -r a b c <<<"$have"
	IFS=. read -r x y z <<<"$want"

	[[ ${a:-} =~ ^[0-9]+$ &&
		${b:-} =~ ^[0-9]+$ &&
		${c:-} =~ ^[0-9]+$ ]] ||
		return 1

	((\
	10#$a > 10#$x || (\
	10#$a == 10#$x && \
	10#$b > 10#$y) || (\
	10#$a == 10#$x && \
	10#$b == 10#$y && \
	10#$c >= 10#$z)))

}

install_tree_sitter() (
	set -eo pipefail

	local current=""
	local platform
	local architecture
	local pattern
	local tmp

	if has tree-sitter; then
		current="$(
			tree-sitter --version |
				awk '{print $2}'
		)"

		if version_at_least "$current" 0.26.1; then
			log "Tree-sitter CLI already available: $current"
			return 0
		fi
	fi

	if [[ $DRY_RUN == 1 ]]; then
		log "Would install a verified Tree-sitter CLI release to ~/.local/bin."
		return 0
	fi

	case "$OS" in
	Linux)
		platform="linux"
		;;

	Darwin)
		platform="macos"
		;;

	*)
		errexit "Tree-sitter download unsupported on $OS"
		;;
	esac

	case "$ARCH" in
	x86_64)
		architecture="(x64|x86_64)"
		;;

	arm64 | aarch64)
		architecture="(arm64|aarch64)"
		;;

	*)
		errexit "Unsupported architecture: $ARCH"
		;;
	esac

	## Prefer the current zip layout; also support releases using the older gzip layout.
	pattern="^tree-sitter(-cli)?-${platform}-${architecture}\\.(zip|gz)$"

	tmp="$(mktemp -d)"
	trap 'rm -rf -- "$tmp"' EXIT

	release_asset \
		tree-sitter/tree-sitter \
		"${TREE_SITTER_RELEASE:-latest}" \
		"$pattern" \
		"$tmp/asset"

	if unzip -tq "$tmp/asset" >/dev/null 2>&1; then
		unzip -q "$tmp/asset" -d "$tmp/unpacked"

		local binary=""
		local candidate

		while IFS= read -r candidate; do
			[[ -z $binary ]] ||
				errexit "Multiple tree-sitter binaries in archive."

			binary=$candidate
		done < <(
			find "$tmp/unpacked" -type f -name tree-sitter
		)

		[[ -n $binary ]] ||
			errexit "No tree-sitter executable in archive."

		cp -- "$binary" "$tmp/tree-sitter"
	else
		gzip -dc "$tmp/asset" >"$tmp/tree-sitter"
	fi

	chmod +x "$tmp/tree-sitter"

	"$tmp/tree-sitter" --version

	mkdir -p -- "$BIN_DIR"

	install -m 0755 \
		"$tmp/tree-sitter" \
		"$BIN_DIR/tree-sitter"

	version_at_least \
		"$("$BIN_DIR/tree-sitter" --version | awk '{print $2}')" \
		0.26.1 ||
		errexit "Tree-sitter CLI is too old."
)

install_source() (
	set -eo pipefail

	local ref=${1:-stable}
	local tmp
	local command

	if [[ $SKIP_DEPS == 0 && -n $BACKEND ]]; then
		install_group build
	fi

	if [[ $DRY_RUN == 1 ]]; then
		log "Would clone ref '$ref', build in '$BUILD_DIR', and install under '$PREFIX'."
		return 0
	fi

	for command in git make cmake ninja curl; do
		need "$command"
	done

	mkdir -p -- "$BUILD_DIR"

	tmp="$(mktemp -d "$BUILD_DIR/source.XXXXXXXX")"
	trap 'rm -rf -- "$tmp"' EXIT

	git clone \
		--depth 1 \
		--branch "$ref" \
		https://github.com/neovim/neovim.git \
		"$tmp/neovim"

	(
		cd -- "$tmp/neovim"

		make \
			CMAKE_BUILD_TYPE=RelWithDebInfo \
			CMAKE_INSTALL_PREFIX="$PREFIX"

		make \
			CMAKE_INSTALL_PREFIX="$PREFIX" \
			install
	)

	"$PREFIX/bin/nvim" --version

	mkdir -p -- "$BIN_DIR"

	[[ ! -d $BIN_DIR/nvim ]] ||
		errexit "$BIN_DIR/nvim is a directory."

	ln -sf -- \
		"$PREFIX/bin/nvim" \
		"$BIN_DIR/nvim"

	## This function runs in a subshell; the caller sets NVIM_CHECK too.
	# shellcheck disable=SC2034
	NVIM_CHECK="$BIN_DIR/nvim"
)

install_appimage() (
	set -eo pipefail

	local asset
	local tmp

	[[ $OS == Linux ]] ||
		errexit "AppImage is Linux-only."

	case "$ARCH" in
	x86_64)
		asset="nvim-linux-x86_64.appimage"
		;;

	arm64 | aarch64)
		asset="nvim-linux-arm64.appimage"
		;;

	*)
		errexit "Unsupported AppImage architecture: $ARCH"
		;;
	esac

	if [[ $DRY_RUN == 1 ]]; then
		log "Would verify and install $asset to $BIN_DIR/nvim"
		return 0
	fi

	tmp="$(mktemp -d)"
	trap 'rm -rf -- "$tmp"' EXIT

	release_asset \
		neovim/neovim \
		"${NVIM_RELEASE:-latest}" \
		"^${asset//./\\.}$" \
		"$tmp/nvim"

	chmod +x "$tmp/nvim"

	"$tmp/nvim" --version ||
		errexit "AppImage could not run. Install FUSE 2 support (--with fuse) or choose another method."

	mkdir -p -- "$BIN_DIR"

	## Do not follow an old source-install symlink while writing the new file.
	[[ ! -d $BIN_DIR/nvim ]] ||
		errexit "$BIN_DIR/nvim is a directory."

	rm -f -- "$BIN_DIR/nvim"

	install -m 0755 \
		"$tmp/nvim" \
		"$BIN_DIR/nvim"
)

install_flatpak() {
	[[ $OS == Linux ]] ||
		errexit "Flatpak mode is Linux-only."

	if ! has flatpak; then
		[[ $SKIP_DEPS == 0 ]] ||
			errexit "flatpak is missing."

		install_group flatpak
	fi

	run flatpak remote-add \
		--user \
		--if-not-exists \
		flathub \
		https://flathub.org/repo/flathub.flatpakrepo

	run flatpak install \
		--user \
		-y \
		flathub \
		io.neovim.nvim
}

install_font() (
	set -eo pipefail

	if [[ $OS == Darwin && $BACKEND == brew ]]; then
		install_group font
		return 0
	fi

	[[ $OS == Linux ]] ||
		errexit "Font installer supports Linux and Homebrew/macOS."

	install_group font

	if [[ $DRY_RUN == 1 ]]; then
		log "Would install FiraCode Nerd Font in the user fonts directory."
		return 0
	fi

	local tmp
	local destination

	tmp="$(mktemp -d)"
	trap 'rm -rf -- "$tmp"' EXIT

	release_asset \
		ryanoasis/nerd-fonts \
		latest \
		'^FiraCode\.zip$' \
		"$tmp/font.zip"

	destination="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/FiraCodeNerdFont"

	mkdir -p -- "$destination"

	unzip -oq "$tmp/font.zip" -d "$destination"

	fc-cache -f "$destination"
)
