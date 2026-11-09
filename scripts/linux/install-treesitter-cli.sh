#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

if ! exec bash "$SCRIPT_DIR/install.sh" \
	--deps-only \
	"$@" 2>&1; then
	errexit "Failed installing tree-sitter-cli"
fi
