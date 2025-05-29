#!/bin/bash

## Configuration to download
CONFIG="nvim"
OUTPUT_DIR="."

## Get URL to release archive
echo "Getting latest $CONFIG release URL"
RELEASE_URL=$(curl -s https://api.github.com/repos/redjax/neovim/releases/latest \
  | grep "browser_download_url" \
  | grep "$CONFIG" \
  | cut -d '"' -f 4)
if [[ $? -ne 0 ]]; then
  echo "[ERROR] Failed getting download URL for latest $CONFIG release"
  exit 1
fi

## Set filename from URL
ARCHIVE_FILENAME=$(basename "$RELEASE_URL")

## Download config
echo "Downloading $ARCHIVE_FILENAME release from: $RELEASE_URL"
curl -L "$RELEASE_URL" -o "$OUTPUT_DIR/$ARCHIVE_FILENAME"
if [[ $? -ne 0 ]]; then
  echo "[ERROR] Failed downloading latest $CONFIG release"
  exit 1
else
  echo "[SUCCESS] Downloaded latest $CONFIG release to $OUTPUT_DIR/$ARCHIVE_FILENAME"
  exit 0
fi
