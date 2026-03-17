#!/bin/bash

## Convenience wrapper — delegates to containers/build-and-test.sh
## Usage: ./scripts/docker/build.sh [config-name] [base-image]
##   config-name: nvim, nvim-lazyvim, nvim-work, nvim-noplugins, nvim-kickstart (default: nvim)
##   base-image:  debian:stable-slim, ubuntu:24.04, fedora:41, archlinux:base, alpine:3.21 (default: debian:stable-slim)

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

exec "${REPO_ROOT}/containers/build-and-test.sh" "$@"
