#!/usr/bin/env bash

## Installation and dependency management functions

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "${THIS_DIR}/path.sh"
. "${THIS_DIR}/utils.sh"

function npm_global_package_installed() {
    ## Check if a global npm package is already installed
    local pkg="$1"
    local npm_root

    if ! command -v npm >/dev/null 2>&1; then
        return 1
    fi

    npm_root=$(npm root -g 2>/dev/null)
    [[ -n "$npm_root" && -d "$npm_root/$pkg" ]]
}

function install_missing_npm_global_packages() {
    ## Install only missing npm packages in one invocation for faster installs
    local -n npm_deps=$1
    local -a missing_pkgs=()

    for pkg in "${npm_deps[@]}"; do
        [[ "$pkg" =~ ^# ]] && continue

        if npm_global_package_installed "$pkg"; then
            echo "Skipping NPM package (already installed): $pkg"
            continue
        fi

        missing_pkgs+=("$pkg")
    done

    if [[ ${#missing_pkgs[@]} -eq 0 ]]; then
        echo "All requested NPM packages are already installed"
        return 0
    fi

    echo "Installing missing NPM packages: ${missing_pkgs[*]}"
    npm install -g "${missing_pkgs[@]}"
}

##########################
# Nerd Font Installation #
##########################

function install_nerdfont() {
    ## Install the FiraCode nerd font

    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    FONT_DIR="$HOME/.local/share/fonts"
    TEMP_DIR="/tmp/firacode-nerdfont"

    if [[ ! -d "$FONT_DIR/FiraCode" ]]; then
        echo ""
        echo "[ Neovim Setup - Install NerdFont ]"
        echo ""
    else
        return
    fi

    if [[ ! -d $FONT_DIR ]]; then
        echo "Creating directory '$FONT_DIR'"
        mkdir -pv "$FONT_DIR"
    fi

    if [[ ! -d $TEMP_DIR ]]; then
        echo "Creating directory '$TEMP_DIR'"
        mkdir -pv "$TEMP_DIR"
    fi

    if [[ ! -f "${TEMP_DIR}/FiraCode.zip" ]]; then
        echo "Downloading FiraCode font..."
        cd $TEMP_DIR

        curl -LO "$FONT_URL"
    fi

    if [[ ! -d "${TEMP_DIR}/FiraCode" ]]; then
        echo "Unzipping FiraCode font..."

        unzip -o FiraCode.zip -d FiraCode
    fi

    if [[ ! -d "${FONT_DIR}/FiraCode" ]]; then
        echo "Installing FiraCode to $FONT_DIR"

        cp -R "${TEMP_DIR}/FiraCode" "${FONT_DIR}"
    fi

    echo ""
    echo "Refreshing font cache"
    fc-cache -fv

    ## Change path back to starting point
    return_to_root
}

###############################
# System Package Dependencies #
###############################

function install_dependencies_apt() {
    ## Install all neovim dependencies
    ## Expects array name as first parameter: install_dependencies_apt NVIM_APT_DEPENDENCIES
    local -n apt_deps=$1

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ($PKG_MGR) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo apt update
    sudo apt install -y "${apt_deps[@]}"

    if ! command -v nvm >/dev/null 2>&1; then
        echo "[WARNING] nvm is not installed."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        source ~/.bashrc
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "[WARNING] node is not installed."
        nvm install --lts
        nvm alias default lts/*
    fi

    if ! command -v tree-sitter >/dev/null 2>&1; then
        echo "[WARNING] tree-sitter is not installed."
        npm install -g tree-sitter-cli
    fi

    if npm_global_package_installed "neovim"; then
        echo "Skipping npm install for neovim (already installed globally)"
    else
        echo "Installing neovim with npm"
        npm install -g neovim
    fi
}

function install_dependencies_dnf() {
    ## Install all neovim dependencies
    
    ## Expects array name as first parameter: install_dependencies_dnf NVIM_DNF_DEPENDENCIES
    local -n dnf_deps=$1

    echo ""
    echo "[ Neovim Setup - Install neovim dependencies ($PKG_MGR) ]"
    echo "Please enter your admin password when prompted to install dependency packages"
    echo ""

    sudo dnf update -y
    sudo dnf install -y "${dnf_deps[@]}"
    sudo dnf install -y @development-tools

    if ! command -v nvm >/dev/null 2>&1; then
        echo "[WARNING] nvm is not installed."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        source ~/.bashrc
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "[WARNING] node is not installed."
        nvm install --lts
        nvm alias default lts/*
    fi

    if ! command -v tree-sitter >/dev/null 2>&1; then
        echo "[WARNING] tree-sitter is not installed."
        npm install -g tree-sitter-cli
    fi

    if npm_global_package_installed "neovim"; then
        echo "Skipping npm install for neovim (already installed globally)"
    else
        echo "Installing neovim with npm"
        npm install -g neovim
    fi
}

#######################
# Neovim Installation #
#######################

function install_neovim_appimg() {
    ## Install Neovim from Github release

    TEMP_DIR="/tmp/neovim"
    NEOVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"

    echo ""
    echo "[ Neovim Setup - Install neovim (appimg) ]"
    echo ""

    if [[ ! -d $TEMP_DIR ]]; then
        echo "Creating directory: $TEMP_DIR"

        mkdir -pv "${TEMP_DIR}"
    fi

    cd $TEMP_DIR

    if [[ ! -f "${TEMP_DIR}/nvim.appimage" ]]; then
        echo "Downloading latest stable release from Github"
        curl -LO "${NEOVIM_DOWNLOAD_URL}"
    fi

    ## Make it executable
    chmod +x nvim.appimage

    # Replace the old version
    sudo mv nvim.appimage /usr/bin/nvim

    # Verify the update
    nvim --version

    return_to_root
}

function install_neovim_source() {
    
    declare -a APT_DEPENDS=("git" "ninja-build" "gettext" "libtool" "libtool-bin" "autoconf" "automake" "cmake" "g++" "pkg-config" "unzip" "curl" "doxygen")
    declare -a DNF_DEPENDS=("git" "ninja-build" "libtool" "autoconf" "automake" "cmake" "gcc" "gcc-c++" "make" "pkgconfig" "unzip" "patch" "gettext" "curl")

    if [[ $PKG_MGR == "dnf" ]]; then
        echo "Installing build tools for neovim with dnf"
        sudo $PKG_MGR install -y "${DNF_DEPENDS[@]}"
        eval_last $?
    elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
        echo "Installing build tools for neovim with apt"
        sudo $PKG_MGR install -y "${APT_DEPENDS[@]}"
        eval_last $?
    else
        echo "[WARNING] Building neovim from source with package manager '${PKG_MGR}' is not supported."
        exit 1
    fi

    cd $NEOVIM_MAKE_BUILD_DIR
    eval_last $?

    if [[ ! -d "neovim" ]]; then
        echo "Cloning neovim repeository"
        git clone https://github.com/neovim/neovim.git
    else
        echo "Neovim repository already exists at ${NEOVIM_MAKE_BUILD_DIR}/neovim. Changes will be pulled, and Neovim will be rebuilt."
    fi

    cd neovim
    eval_last $?
    echo "Running a git pull to get any changes"
    git pull
    eval_last $?

    ## Remove Make cache if in container
    if [[ $CONTAINER_ENV -eq 1 || "${CONTAINER_ENV}" == "1" ]]; then
        if [[ -d "${NEOVIM_MAKE_BUILD_DIR}/neovim/cmake.deps/CMakeLists.txt" ]]; then
            echo "[WARNING] Previous CMake build detected while building in container environment.
            Removing ${NEOVIM_MAKE_BUILD_DIR}/neovim/cmake.deps directory for a clean build.
            "

            rm -r "${NEOVIM_MAKE_BUILD_DIR}/neovim/cmake.deps}"
            eval_last $?
        fi
    fi
    
    echo "Building Neovim"
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    eval_last $?

    echo "Installing Neovim after building source"
    sudo make install
    eval_last $?

    echo "[SUCCESS] Neovim installed" 
}

############################
# Tree-sitter Installation #
############################

function install_treesitter() {
    ## Install tree-sitter CLI
    
    if command -v tree-sitter >/dev/null 2>&1; then
        echo "tree-sitter already installed: $(tree-sitter --version)"
        return 0
    fi

    ## Detect architecture
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)
            GITHUB_ARCH="x86_64"
            ;;
        aarch64|arm64)
            GITHUB_ARCH="aarch64"
            ;;
        *)
            echo "Unsupported architecture: $ARCH. Will try npm fallback." >&2
            GITHUB_ARCH=""
            ;;
    esac

    ## Try GitHub release download first
    if [[ -n "$GITHUB_ARCH" ]]; then
        echo "Attempting to install tree-sitter-cli from GitHub releases"
        
        INSTALL_DIR="${HOME}/.local/bin"
        mkdir -p "$INSTALL_DIR"
        
        ## Get latest release download URL
        RELEASE_URL="https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest"
        
        if command -v curl >/dev/null 2>&1; then
            ## Extract download URL for the appropriate architecture
            DOWNLOAD_URL=$(curl -s "$RELEASE_URL" | grep -o "https://github.com/tree-sitter/tree-sitter/releases/download/[^\"]*linux-$GITHUB_ARCH\.gz" | head -1)
            
            if [[ -n "$DOWNLOAD_URL" ]]; then
                TEMP_DIR=$(mktemp -d)
                trap "rm -rf $TEMP_DIR" EXIT
                
                echo "Downloading from: $DOWNLOAD_URL"
                if curl -L -o "$TEMP_DIR/tree-sitter.gz" "$DOWNLOAD_URL"; then
                    if gunzip -c "$TEMP_DIR/tree-sitter.gz" > "$INSTALL_DIR/tree-sitter"; then
                        chmod +x "$INSTALL_DIR/tree-sitter"
                        
                        ## Ensure ~/.local/bin is in PATH
                        if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
                            echo "Adding $INSTALL_DIR to PATH"
                            export PATH="$INSTALL_DIR:$PATH"
                        fi
                        
                        if command -v tree-sitter >/dev/null 2>&1; then
                            echo "tree-sitter installed from GitHub: $(tree-sitter --version)"
                            return 0
                        fi
                    fi
                fi
            fi
        fi
        
        echo "GitHub download failed or curl not available. Falling back to npm" >&2
    fi

    ## Fallback to npm install
    if ! command -v npm >/dev/null 2>&1; then
        echo "NPM is not installed and GitHub download failed. Please install Node.js/NPM first." >&2
        return 1
    fi

    echo "Installing tree-sitter-cli with npm"
    if ! npm install -g tree-sitter-cli; then
        echo "Failed to install tree-sitter-cli" >&2
        return 1
    fi

    if command -v tree-sitter >/dev/null 2>&1; then
        echo "tree-sitter installed: $(tree-sitter --version)"
        return 0
    fi

    echo "tree-sitter-cli installed but 'tree-sitter' is not in PATH yet." >&2
    echo "Restart your shell and verify with: tree-sitter --version" >&2
    return 1
}

########################
# Neovide Installation #
########################

function install_neovide() {
    ## Install Neovide GUI
    
    # Paths
    NEOVIDE_BIN_DIR="$HOME/.local/bin"
    NEOVIDE_DESKTOP_DIR="$HOME/.local/share/applications"
    NEOVIDE_ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
    NEOVIDE_DESKTOP_FILE="$NEOVIDE_DESKTOP_DIR/neovide.desktop"
    NEOVIDE_ICON_PATH="$NEOVIDE_ICON_DIR/neovide.png"

    GITHUB_API="https://api.github.com/repos/neovide/neovide/releases/latest"

    mkdir -p "$NEOVIDE_BIN_DIR" "$NEOVIDE_DESKTOP_DIR" "$NEOVIDE_ICON_DIR"

    ## Check if already installed
    if command -v neovide >/dev/null 2>&1; then
        echo "neovide is already installed: $(neovide --version)"
        return 0
    fi

    detect_distro() {
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            echo "$ID"
        else
            echo "unknown"
        fi
    }

    get_latest_version() {
        curl -s "$GITHUB_API" | grep -Po '"tag_name": "\K.*?(?=")'
    }

    install_native_package() {
        local distro=$1
        if [[ "$distro" =~ ^(arch|manjaro)$ ]]; then
            echo "Installing Neovide via pacman (Arch Linux)..."
            sudo pacman -Sy --noconfirm neovide && return 0 || return 1
        elif command -v nix-env >/dev/null 2>&1; then
            echo "Installing Neovide via nix..."
            nix-env -iA nixpkgs.neovide && return 0 || return 1
        else
            return 1
        fi
    }

    install_tarball() {
        local arch=$(uname -m)
        if [[ "$arch" != "x86_64" ]]; then
            echo "No tarball available for architecture: $arch"
            return 1
        fi

        local version
        version=$(get_latest_version)
        local tarball_url="https://github.com/neovide/neovide/releases/download/${version}/neovide-linux-x86_64.tar.gz"

        echo "Downloading tarball version $version..."
        curl -L -o "/tmp/neovide.tar.gz" "$tarball_url"

        echo "Extracting Neovide binary..."
        tar -xf /tmp/neovide.tar.gz -C /tmp

        echo "Installing binary to $NEOVIDE_BIN_DIR..."
        chmod +x /tmp/neovide
        mv /tmp/neovide "$NEOVIDE_BIN_DIR/"

        return 0
    }

    install_appimage() {
        local arch=$(uname -m)
        if [[ "$arch" != "x86_64" ]]; then
            echo "AppImage only available for x86_64 for now."
            return 1
        fi

        echo "Fetching latest AppImage URL from GitHub API..."
        local appimage_url
        appimage_url=$(curl -s "$GITHUB_API" | grep "browser_download_url" | grep "appimage" | cut -d '"' -f 4 | head -n1)

        if [ -z "$appimage_url" ]; then
            echo "Failed to find AppImage URL."
            return 1
        fi

        echo "Downloading AppImage..."
        curl -L -o "$NEOVIDE_BIN_DIR/neovide" "$appimage_url"
        chmod +x "$NEOVIDE_BIN_DIR/neovide"

        return 0
    }

    echo "[ Installing Neovide ]"
    
    ## Try native package manager first
    local distro
    distro=$(detect_distro)
    if install_native_package "$distro"; then
        echo "[SUCCESS] Neovide installed via native package manager"
        return 0
    fi

    ## Try tarball
    if install_tarball; then
        echo "[SUCCESS] Neovide installed from tarball"
        return 0
    fi

    ## Try AppImage
    if install_appimage; then
        echo "[SUCCESS] Neovide installed from AppImage"
        return 0
    fi

    echo "[WARNING] Could not install Neovide via any method"
    return 1
}

#################################
# LSP Requirements Installation #
#################################

function install_lsp_requirements() {
    ## Install LSP language server dependencies
    
    ## Define NPM dependencies
    local -a NPM_DEPENDENCIES=(
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
        "sql-formatter"
    )

    ## Define Python dependencies
    local -a PYTHON_DEPENDENCIES=(
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

    ## Define Rust/Cargo dependencies
    local -a CARGO_DEPENDENCIES=(
        "stylua"
    )

    ## Define Go dependencies
    local -a GO_DEPENDENCIES=(
        "mvdan.cc/sh/v3/cmd/shfmt@latest"
        "github.com/rhysd/actionlint/cmd/actionlint@latest"
        "github.com/incu6us/goimports-reviser/v3@latest"
        "github.com/google/yamlfmt/cmd/yamlfmt@latest"
        "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    )

    echo "[ Installing LSP Requirements ]"

    ## Determine Python package manager
    local PYTHON_PKG_MANAGER="pip"
    local PYTHON_TOOL_MANAGER="pipx"
    
    if command -v uv >/dev/null 2>&1; then
        echo "Using uv for Python dependencies"
        PYTHON_PKG_MANAGER="uv"
        PYTHON_TOOL_MANAGER="uv"
    else
        echo "Using pip for Python dependencies"
    fi

    ## Install NPM dependencies
    if command -v npm >/dev/null 2>&1; then
        if ! install_missing_npm_global_packages NPM_DEPENDENCIES; then
            echo "Error installing one or more NPM dependencies" >&2
        fi
    else
        echo "NPM is not installed. Please install Node.js and NPM, then re-run the script." >&2
        return 1
    fi

    ## Install Python dependencies
    if command -v "$PYTHON_PKG_MANAGER" >/dev/null 2>&1; then
        local PYTHON_CMD="python"
        if command -v python3 >/dev/null 2>&1; then
            PYTHON_CMD="python3"
        fi

        for pkg in "${PYTHON_DEPENDENCIES[@]}"; do
            if "$PYTHON_CMD" -m pip show "$pkg" >/dev/null 2>&1; then
                echo "Skipping Python package (already installed): $pkg"
                continue
            fi

            echo "Installing Python package: $pkg"
            if [[ "$PYTHON_PKG_MANAGER" == "uv" ]]; then
                if ! uv pip install --system "$pkg"; then
                    echo "Error installing Python dependency '$pkg' with uv" >&2
                fi
            else
                if ! "$PYTHON_PKG_MANAGER" install "$pkg"; then
                    echo "Error installing Python dependency '$pkg' with pip" >&2
                fi
            fi
        done
    else
        echo "Python package manager ($PYTHON_PKG_MANAGER) is not installed." >&2
        return 1
    fi

    ## Install Rust/Cargo dependencies
    if command -v cargo >/dev/null 2>&1; then
        for pkg in "${CARGO_DEPENDENCIES[@]}"; do
            echo "Installing Cargo package: $pkg"
            if ! cargo install "$pkg"; then
                echo "Error installing Cargo dependency '$pkg'" >&2
            fi
        done
    else
        echo "Cargo is not installed. Skipping Rust dependencies." >&2
    fi

    ## Install Go dependencies
    if command -v go >/dev/null 2>&1; then
        for pkg in "${GO_DEPENDENCIES[@]}"; do
            echo "Installing Go package: $pkg"
            if ! go install "$pkg"; then
                echo "Error installing Go dependency '$pkg'" >&2
            fi
        done
    else
        echo "Go is not installed. Skipping Go dependencies." >&2
    fi

    echo "[SUCCESS] LSP requirements installed"
    return 0
}
