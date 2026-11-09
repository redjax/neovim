#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

if ! exec bash "$SCRIPT_DIR/install.sh" \
	--deps-only \
	--with uv \
	"$@" 2>&1; then
	errexit "Failed installing Uv."
fi
