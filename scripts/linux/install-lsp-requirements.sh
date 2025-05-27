#!/usr/bin/env bash

## Define NPM dependencies
NPM_DEPENDENCIES=(
    "neovim"
    "gh-actions-language-server"
    "azure-pipelines-language-server"
    "bash-language-server"
    "css-variables-language-server"
    "@microsoft/compose-language-service"
    "dockerfile-language-server-nodejs"
    "graphql-language-service-cli"
    "pyright"
    "@stoplight/spectral-cli"
    "yaml-language-server"
    # "@ansible/ansible-language-server"
    # "css-language-server"
    # "cssmodules-language-server"
    # "eslint"
    # "@bmewburn/vscode-html-languageserver"
    # "@aws/lsp-json"
    # "sql-language-server"
    # "svelte-language-server"
)

## Define Python dependencies
PYTHON_DEPENDENCIES=(
    "nginx-language-server"
    "ruff"
    "ruff-lsp"
    "salt-lsp"
    "sqruff"
    "cmake-language-server"
)

## Determine Python package manager
if command -v uv >/dev/null 2>&1; then
    echo "Using uv for Python dependencies"
    PYTHON_PKG_MANAGER="uv"
else
    echo "Using pip for Python dependencies"
    PYTHON_PKG_MANAGER="pip"
fi

## Install NPM dependencies
for pkg in "${NPM_DEPENDENCIES[@]}"; do
    ## Skip commented dependencies
    [[ "$pkg" =~ ^# ]] && continue
    echo "Installing NPM package: $pkg"
    if ! npm install -g "$pkg"; then
        echo "Error installing NPM dependency '$pkg'" >&2
    fi
done

## Install Python dependencies
for pkg in "${PYTHON_DEPENDENCIES[@]}"; do
    ## Skip commented dependencies
    [[ "$pkg" =~ ^# ]] && continue
    echo "Installing Python package: $pkg"
    if [[ "$PYTHON_PKG_MANAGER" == "uv" ]]; then
        if ! uv tool install "$pkg"; then
            echo "Error installing Python dependency '$pkg'" >&2
        fi
    else
        if ! pip install "$pkg"; then
            echo "Error installing Python dependency '$pkg'" >&2
        fi
    fi
done
