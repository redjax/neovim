#!/usr/bin/env bash
set -euo pipefail

## Install fzf directly from an upstream GitHub release
#
#  Usage:
#    bash lib/install-fzf.sh
#    bash lib/install-fzf.sh 0.74.5
#    bash lib/install-fzf.sh latest

VERSION="${1:-${FZF_VERSION:-0.74.5}}"
INSTALL_DIR="${FZF_INSTALL_DIR:-"$HOME/.local/bin"}"

## Ensure installer dependencies are available
for cmd in curl jq tar sha256sum install; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERROR] Required command not found: $cmd" >&2
    exit 1
  fi
done

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "[ERROR] This installer supports Linux only." >&2
  exit 1
fi

## Detect architecture
case "$(uname -m)" in
x86_64)
  ARCH="amd64"
  ;;
aarch64 | arm64)
  ARCH="arm64"
  ;;
*)
  echo "[ERROR] Unsupported architecture: $(uname -m)" >&2
  exit 1
  ;;
esac

## Skip an already-installed pinned version
if [[ "$VERSION" != "latest" ]]; then
  VERSION="${VERSION#v}"

  if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "[ERROR] Expected a version such as 0.74.5, or latest." >&2
    exit 1
  fi

  if [[ -x "$INSTALL_DIR/fzf" ]]; then
    INSTALLED_VERSION="$(
      "$INSTALL_DIR/fzf" --version | awk '{print $1}'
    )"

    if [[ "$INSTALLED_VERSION" == "$VERSION" ]]; then
      echo "[INFO] fzf $VERSION already installed: $INSTALL_DIR/fzf"
      exit 0
    fi
  fi
fi

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_DIR"' EXIT

## Get release metadata
API_URL="https://api.github.com/repos/junegunn/fzf/releases"

if [[ "$VERSION" == "latest" ]]; then
  API_URL+="/latest"
else
  API_URL+="/tags/v${VERSION}"
fi

CURL_ARGS=(
  --fail
  --silent
  --show-error
  --location
  --retry 3
)

API_ARGS=(
  -H "Accept: application/vnd.github+json"
)

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  API_ARGS+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

echo "[INFO] Fetching fzf release metadata"
curl "${CURL_ARGS[@]}" "${API_ARGS[@]}" \
  "$API_URL" -o "$TEMP_DIR/release.json"

TAG="$(jq -er '.tag_name' "$TEMP_DIR/release.json")"
ASSET="fzf-${TAG#v}-linux_${ARCH}.tar.gz"

DOWNLOAD_URL="$(
  jq -er --arg name "$ASSET" \
    '.assets[] |
         select(.name == $name) |
         .browser_download_url' \
    "$TEMP_DIR/release.json"
)"

DIGEST="$(
  jq -er --arg name "$ASSET" \
    '.assets[] |
         select(.name == $name) |
         .digest |
         select(type == "string") |
         select(test("^sha256:[0-9a-fA-F]{64}$"))' \
    "$TEMP_DIR/release.json"
)" || {
  echo "[ERROR] No SHA-256 digest available; refusing installation." >&2
  exit 1
}

echo "[INFO] Downloading $ASSET"
curl "${CURL_ARGS[@]}" \
  "$DOWNLOAD_URL" -o "$TEMP_DIR/$ASSET"

## Verify against the digest published in the GitHub release metadata
echo "[INFO] Verifying SHA-256"
printf '%s  %s\n' "${DIGEST#sha256:}" "$TEMP_DIR/$ASSET" |
  sha256sum --check -

echo "[INFO] Extracting fzf"
tar -xzf "$TEMP_DIR/$ASSET" -C "$TEMP_DIR" fzf
chmod +x "$TEMP_DIR/fzf"

## Verify the executable before replacing an existing installation
DOWNLOADED_VERSION="$(
  "$TEMP_DIR/fzf" --version | awk '{print $1}'
)"

if [[ "$DOWNLOADED_VERSION" != "${TAG#v}" ]]; then
  echo "[ERROR] Downloaded binary version does not match release tag." >&2
  exit 1
fi

echo "[INFO] Installing fzf to $INSTALL_DIR"
install -d "$INSTALL_DIR"
install -m 0755 "$TEMP_DIR/fzf" "$INSTALL_DIR/fzf"

echo "[SUCCESS] Installed $INSTALL_DIR/fzf"
"$INSTALL_DIR/fzf" --version
