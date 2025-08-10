#!/usr/bin/env bash
set -e

# Paths
NEOVIDE_BIN_DIR="$HOME/.local/bin"
NEOVIDE_DESKTOP_DIR="$HOME/.local/share/applications"
NEOVIDE_ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
NEOVIDE_DESKTOP_FILE="$NEOVIDE_DESKTOP_DIR/neovide.desktop"
NEOVIDE_ICON_PATH="$NEOVIDE_ICON_DIR/neovide.png"

GITHUB_API="https://api.github.com/repos/neovide/neovide/releases/latest"

mkdir -p "$NEOVIDE_BIN_DIR" "$NEOVIDE_DESKTOP_DIR" "$NEOVIDE_ICON_DIR"

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

fuse_supported() {
  lsmod | grep -q fuse && [[ -c /dev/fuse ]]
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

install_build_from_source() {
  echo "Installing Rust if not found..."
  if ! command -v cargo >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi

  echo "Cloning Neovide repo and building..."
  local tmpdir
  tmpdir=$(mktemp -d)
  git clone https://github.com/neovide/neovide.git "$tmpdir"
  cd "$tmpdir"
  cargo build --release

  echo "Installing binary..."
  cp target/release/neovide "$NEOVIDE_BIN_DIR/"
  chmod +x "$NEOVIDE_BIN_DIR/neovide"

  cd -
  rm -rf "$tmpdir"
}

create_desktop_entry() {
  echo "Downloading icon..."
  curl -L -o "$NEOVIDE_ICON_PATH" https://raw.githubusercontent.com/neovide/neovide/master/assets/icon.png

  echo "Creating desktop entry..."
  cat > "$NEOVIDE_DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Neovide
Comment=No-nonsense Neovim GUI
Exec=$NEOVIDE_BIN_DIR/neovide %F
Icon=$NEOVIDE_ICON_PATH
Terminal=false
Type=Application
Categories=Utility;TextEditor;
StartupNotify=true
EOF
}

main() {
  mkdir -p "$NEOVIDE_BIN_DIR" "$NEOVIDE_DESKTOP_DIR" "$NEOVIDE_ICON_DIR"
  local distro
  distro=$(detect_distro)
  local arch
  arch=$(uname -m)

  echo "Detected distro: $distro"
  echo "Detected architecture: $arch"

  if install_native_package "$distro"; then
    echo "Installed via native package manager."
  elif install_tarball; then
    echo "Installed via prebuilt tarball."
  elif [[ "$arch" == "x86_64" ]] && fuse_supported && install_appimage; then
    echo "Installed via AppImage."
  else
    echo "Falling back to building from source."
    install_build_from_source
  fi

  create_desktop_entry

  echo "Installation complete!"
  echo "Make sure $NEOVIDE_BIN_DIR is in your PATH to run 'neovide' directly."
  echo "You can launch Neovide from your application launcher."
}

main
