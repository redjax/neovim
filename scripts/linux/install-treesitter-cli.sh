#!/usr/bin/env bash

set -uo pipefail

if ! command -v npm >/dev/null 2>&1; then
  echo "NPM is not installed. Please install Node.js/NPM first." >&2
  exit 1
fi

if command -v tree-sitter >/dev/null 2>&1; then
  echo "tree-sitter already installed: $(tree-sitter --version)"
  exit 0
fi

echo "Installing tree-sitter-cli with npm..."
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
