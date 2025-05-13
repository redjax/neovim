#!/bin/bash

## Set path where script was called from
CWD=$(pwd)

## Determine the OS type
OS_TYPE=$(uname -s)

## Detect container environment
#  Set CONTAINER_ENV=1 to enable
CONTAINER_ENV=${CONTAINER_ENV:-0}

if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
    echo "[DEBUG] Container environment: ${CONTAINER_ENV}"

    ## Pause to allow viewing output in a Docker environment
    # sleep 4
fi

declare -a NPM_DEPENDENCIES=(
    "azure-pipelines-language-server"
    "bash-language-server"
    "css-variables-language-server"
    "@microsoft/compose-language-service"
    "dockerfile-language-server-nodejs"
)

if ! command -v npm --version > /dev/null; then
    echo "NPM is not installed."
    exit 1
fi

echo "Installing language servers with npm"

for npmPkg in "${NPM_DEPENDENCIES[@]}"; do
    npm i -g $npmPkg
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed to install npm package '$npmPkg'."
    fi
done
