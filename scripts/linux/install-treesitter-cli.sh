#!/usr/bin/env bash

set -uo pipefail

if command -v tree-sitter >/dev/null 2>&1; then
  echo "tree-sitter already installed: $(tree-sitter --version)"
  exit 0
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
            exit 0
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
  exit 1
fi

echo "Installing tree-sitter-cli with npm"
if ! npm install -g tree-sitter-cli; then
  echo "Failed to install tree-sitter-cli" >&2
  exit 1
fi

if command -v tree-sitter >/dev/null 2>&1; then
  echo "tree-sitter installed: $(tree-sitter --version)"
  exit 0
fi

echo "tree-sitter-cli installed but 'tree-sitter' is not in PATH yet." >&2
echo "Restart your shell and verify with: tree-sitter --version" >&2
exit 1
