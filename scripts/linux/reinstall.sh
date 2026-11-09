#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
		pwd -P
)"

## Re-running installation is not a data reset.
#  Clean data explicitly ussing the clean-config-plugins.sh script.
exec bash "$SCRIPT_DIR/install.sh" "$@"
