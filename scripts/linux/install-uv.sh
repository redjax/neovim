#!/bin/bash

if command -v uv >/dev/null 2>&1; then
    echo "uv is already installed."
    exit 0
fi

if command -v curl >/dev/null 2>&1; then
  echo "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to install uv."
  fi
elif command -v wget >/dev/null 2>&1; then
  echo "Installing uv"
  wget -qO- https://astral.sh/uv/install.sh | sh
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to install uv."
  fi
else
  echo "[ERROR] Missing both curl & wget. Install one or both and try again."
  exit 1
fi
