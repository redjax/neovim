#!/usr/bin/env bash

__NEOVIM_PATH_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT=$(realpath -m "${__NEOVIM_PATH_LIB_DIR}/../../..")
unset __NEOVIM_PATH_LIB_DIR

function return_to_root() {
    cd "${REPO_ROOT}"
}
