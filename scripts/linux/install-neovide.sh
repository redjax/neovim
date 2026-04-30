#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${THIS_DIR}/lib"

## Source lib scripts
. "${LIB_DIR}/path.sh"
. "${LIB_DIR}/install-depends.sh"

## Call the Neovide installation function
install_neovide
exit $?
