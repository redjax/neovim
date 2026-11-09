#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

if ! exec bash "$SCRIPT_DIR/install.sh" \
	--deps-only \
	--with neovide \
	"$@" 2>&1; then
	errexit "[ERROR] Failed installing Neovide"
fi
