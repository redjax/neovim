#!/usr/bin/env bash

## Define NPM dependencies
NPM_DEPENDENCIES=(
    "alex"
    "neovim"
    "gh-actions-language-server"
    "azure-pipelines-language-server"
    "bash-language-server"
    "css-variables-language-server"
    "markdownlint"
    "markdownlint-cli2"
    "@microsoft/compose-language-service"
    "dockerfile-language-server-nodejs"
    "graphql-language-service-cli"
    "pyright"
    "@stoplight/spectral-cli"
    "yaml-language-server"
    "textlint"
    "write-good"
    "prettier"
    "stylelint"
    "write-good"
    "sql-formatter"
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
    "pyyaml"
    "nginx-language-server"
    "pynvim"
    "ruff"
    "ruff-lsp"
    "salt-lsp"
    "sqruff"
    "cmake-language-server"
    "proselint"
    "mdformat"
    "ansible-lint"
    "yamlfix"
    "sqlfmt"
    "sqlformat"
)

## Define Python tools (installed with uv tool install or pipx)
PYTHON_TOOL_DEPENDENCIES=()

## Define Rust/Cargo dependencies
CARGO_DEPENDENCIES=(
    "stylua"
)

## Define Go dependencies
GO_DEPENDENCIES=(
    "mvdan.cc/sh/v3/cmd/shfmt@latest"
    "github.com/rhysd/actionlint/cmd/actionlint@latest"
    "github.com/incu6us/goimports-reviser/v3@latest"
    "github.com/google/yamlfmt/cmd/yamlfmt@latest"
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
)

## Determine Python package manager
if command -v uv >/dev/null 2>&1; then
    echo "Using uv for Python dependencies"
    PYTHON_PKG_MANAGER="uv"
    PYTHON_TOOL_MANAGER="uv"
else
    echo "Using pip for Python dependencies"
    PYTHON_PKG_MANAGER="pip"
    PYTHON_TOOL_MANAGER="pipx"
fi

## Install NPM dependencies
if command -v npm >/dev/null 2>&1; then
    for pkg in "${NPM_DEPENDENCIES[@]}"; do
        ## Skip commented dependencies
        [[ "$pkg" =~ ^# ]] && continue
        echo "Installing NPM package: $pkg"
        if ! npm install -g "$pkg"; then
            echo "Error installing NPM dependency '$pkg'" >&2
        fi
    done
else
    echo "NPM is not installed. Please install Node.js and NPM, then re-run the script." >&2
    exit 1
fi

## Install Python tools
if command -v $PYTHON_TOOL_MANAGER >/dev/null 2>&1; then
    for pkg in "${PYTHON_TOOL_DEPENDENCIES[@]}"; do
        ## Skip commented dependencies
        [[ "$pkg" =~ ^# ]] && continue
        
        echo "Installing Python tool package: $pkg"
        if [[ "$PYTHON_TOOL_MANAGER" == "uv" ]]; then
            if ! uv tool install "$pkg"; then
                echo "Error installing Python tool dependency '$pkg'" >&2
            fi
        else
            echo "Installing Python tool dependency with pipx: $pkg"
            
            if ! pipx install "$pkg"; then
                echo "Error installing Python tool dependency '$pkg'" >&2
                echo "Retrying $pkg install with python -m pipx"

                python -m pipx install $pkg
            fi
        fi
    done
else
    echo "$PYTHON_TOOL_MANAGER is not installed. Please install it and re-run the script." >&2
    exit 1
fi

## Install Python dependencies
if command -v $PYTHON_PKG_MANAGER >/dev/null 2>&1; then
    for pkg in "${PYTHON_DEPENDENCIES[@]}"; do
        ## Skip commented dependencies
        [[ "$pkg" =~ ^# ]] && continue
        echo "Installing Python package: $pkg"
        if [[ "$PYTHON_PKG_MANAGER" == "uv" ]]; then
            if ! uv tool install "$pkg"; then
                echo "Error installing Python dependency '$pkg'" >&2
            fi
        else
            echo "Installing Python dependency with pip: $pkg"
            if ! pip install "$pkg"; then
                echo "Error installing Python dependency '$pkg'" >&2
                echo "Retrying $pkg install with python -m pip"

                python -m pip install $pkg
            fi
        fi
    done
else
    echo "$PYTHON_PKG_MANAGER is not installed. Please install it and re-run the script." >&2
    exit 1
fi

## Install Go dependencies
if command -v go >/dev/null 2>&1; then
    for pkg in "${GO_DEPENDENCIES[@]}"; do
        ## Skip commented dependencies
        [[ "$pkg" =~ ^# ]] && continue
        
        echo "Installing Go package: $pkg"
        if ! go install "$pkg"; then
            echo "Error installing Go dependency '$pkg'" >&2
        fi
    done
else
    echo "Go is not installed, skipping Go dependencies installation"
    exit 0
fi

## Install Cargo dependencies
if command -v cargo >/dev/null 2>&1; then
    for pkg in "${CARGO_DEPENDENCIES[@]}"; do
        ## Skip commented dependencies
        [[ "$pkg" =~ ^# ]] && continue
        echo "Installing Cargo package: $pkg"
        if ! cargo install "$pkg"; then
            echo "Error installing Cargo dependency '$pkg'" >&2
        fi
    done
else
    echo "Cargo is not installed, skipping Cargo dependencies installation"
    exit 0
fi
