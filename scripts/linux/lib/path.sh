#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT=$(realpath -m "${THIS_DIR}/../../../..")

function return_to_root() {
    cd "${REPO_ROOT}"
}
