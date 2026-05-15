#!/bin/bash
set -uo pipefail

VERSION=""

# Parse args
while (( "$#" )); do
  case "$1" in
    -v|--version)
      if [ -n "$2" ] && [[ "${2:0:1}" != "-" ]]; then
        VERSION=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *)
      shift
      ;;
  esac
done

# Fetch latest Go version cleanly
if [[ -z "$VERSION" ]]; then
  echo "Detecting latest Go version..."
  VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | tr -d '\r')
fi

echo "Installing Go $VERSION"

VERSION_NUM="${VERSION#go}"
TARBALL="go${VERSION_NUM}.linux-amd64.tar.gz"
URL="https://go.dev/dl/${TARBALL}"

echo "Downloading: $URL"
curl -LO "$URL"

echo "Removing old Go installation (if exists)..."
sudo rm -rf /usr/local/go

echo "Installing Go to /usr/local/go..."
sudo tar -C /usr/local -xzf "$TARBALL"

echo "Cleaning up..."
rm -f "$TARBALL"

# Ensure PATH
if ! grep -q '/usr/local/go/bin' "$HOME/.bashrc"; then
  echo 'export PATH="/usr/local/go/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Disable Go toolchain auto-downloads
if ! grep -q 'GOTOOLCHAIN=local' "$HOME/.bashrc"; then
  echo 'export GOTOOLCHAIN=local' >> "$HOME/.bashrc"
fi

export PATH="/usr/local/go/bin:$PATH"
export GOTOOLCHAIN=local

echo "Go installation complete."
go version
