#!/usr/bin/env bash
set -Eeuo pipefail

NPM_BIN="$(command -v npm)"
NVIM_BIN="$(command -v nvim)"

UPDATE_NODE=false
UPDATE_NPM=false
UPDATE_NPM_SELF=false
UPDATE_MASON=false
UPDATE_TREESITTER=false
UPDATE_PLUGINS=false
CLEAN_CACHE=false
HEALTH=false
SHOW=false
DRY_RUN=false
DOCTOR=false

function log() {
  printf "\n[%s] %s\n" "$1" "$2"
}

function require_bin() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "[ERROR] missing dependency: $1" >&2
    exit 1
  }
}

function usage() {
  cat <<EOF
Usage:
  update.sh [options]

Options:
  --show           Show outdated global npm packages only
  --dry-run        Inspect Neovim + system updates (no changes)
  --doctor         Run full system diagnostics (read-only)

  --node           Update Node.js (LTS via fnm/nvm)
  --npm            Update global npm packages
  --npm-self       Update npm + corepack itself
  --mason          Update Mason packages
  --treesitter     Update Treesitter parsers
  --plugins        Update Neovim plugins
  --clean          Verify npm cache
  --health         Run Neovim checkhealth
  --all            Run everything except --show/--dry-run/--doctor

Examples:

  update.sh --show
  update.sh --dry-run
  update.sh --doctor
  update.sh --node --npm
  update.sh --all
EOF
}

function parse_args() {
  [[ $# -eq 0 ]] && {
    usage
    exit 0
  }

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --show) SHOW=true ;;
    --dry-run) DRY_RUN=true ;;
    --doctor) DOCTOR=true ;;

    --node) UPDATE_NODE=true ;;
    --npm) UPDATE_NPM=true ;;
    --npm-self) UPDATE_NPM_SELF=true ;;

    --mason) UPDATE_MASON=true ;;
    --treesitter) UPDATE_TREESITTER=true ;;
    --plugins) UPDATE_PLUGINS=true ;;
    --clean) CLEAN_CACHE=true ;;
    --health) HEALTH=true ;;

    --all)
      UPDATE_NODE=true
      UPDATE_NPM=true
      UPDATE_NPM_SELF=true
      UPDATE_MASON=true
      UPDATE_TREESITTER=true
      UPDATE_PLUGINS=true
      CLEAN_CACHE=true
      HEALTH=true
      ;;

    -h | --help)
      usage
      exit 0
      ;;

    *)
      echo "[ERROR] unknown argument: $1" >&2
      exit 1
      ;;
    esac
    shift
  done
}

function update_node() {
  log INFO "Updating Node.js (LTS)"

  if command -v fnm >/dev/null 2>&1; then
    fnm install --lts
    fnm use lts-latest
    fnm default lts-latest
    return
  fi

  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    (
      set +u
      # shellcheck disable=SC1090,SC1091
      source "$HOME/.nvm/nvm.sh"

      nvm install --lts
      nvm use --lts
      nvm alias default lts/*
    )
    return
  fi

  echo "[ERROR] neither fnm nor nvm found (or nvm not loaded)" >&2
  exit 1
}

function update_npm_globals() {
  require_bin npm
  log INFO "Updating global npm packages"
  "$NPM_BIN" update -g
}

function update_npm_self() {
  require_bin npm
  log INFO "Updating npm + corepack"

  npm install -g npm@latest
  npm install -g corepack@latest || true
  corepack enable || true
}

function npm_clean_cache() {
  require_bin npm
  log INFO "Verifying npm cache"
  "$NPM_BIN" cache verify
}

function show_npm_outdated() {
  require_bin npm
  log INFO "Outdated global npm packages"
  "$NPM_BIN" outdated -g --depth=0 || true
}

function dry_run_nvim_plugins() {
  require_bin nvim
  log INFO "Checking plugin status"

  "$NVIM_BIN" --headless "+lua ok, lazy = pcall(require, 'lazy'); if ok then lazy.check() else print('lazy.nvim not installed') end" +qa
}

function dry_run_mason() {
  require_bin nvim
  log INFO "Checking Mason status"

  "$NVIM_BIN" --headless "+lua ok, mason = pcall(require, 'mason'); if ok then print('Mason OK') else print('Mason not installed') end" +qa
}

function dry_run_treesitter() {
  require_bin nvim
  log INFO "Checking Treesitter status"

  "$NVIM_BIN" --headless "+lua ok, ts = pcall(require, 'nvim-treesitter'); if ok then print('Treesitter OK') else print('Treesitter not installed') end" +qa
}

function check_health() {
  require_bin nvim
  log INFO "Running Neovim checkhealth"
  "$NVIM_BIN" --headless "+checkhealth" +qa || true
}

function update_plugins() {
  require_bin nvim
  log INFO "Updating Neovim plugins"
  "$NVIM_BIN" --headless "+Lazy! sync" +qa
}

function update_mason() {
  require_bin nvim
  log INFO "Updating Mason packages"
  "$NVIM_BIN" --headless "+MasonUpdate" +qa
}

function update_treesitter() {
  require_bin nvim
  log INFO "Updating Treesitter parsers"
  "$NVIM_BIN" --headless "+TSUpdateSync" +qa
}

function run_dry_run() {
  log INFO "Dry-run mode (no changes)"

  show_npm_outdated
  dry_run_nvim_plugins
  dry_run_mason
  dry_run_treesitter
}

function run_doctor() {
  log INFO "System diagnostics"

  echo ""
  echo "Node:"
  node -v 2>/dev/null || echo "  node not found"

  echo ""
  echo "npm:"
  npm -v 2>/dev/null || echo "  npm not found"

  echo ""
  echo "npm globals:"
  show_npm_outdated

  echo ""
  echo "npm cache:"
  npm cache verify >/dev/null 2>&1 && echo "  OK" || echo "  WARNING"

  echo ""
  echo "Neovim health:"
  "$NVIM_BIN" --headless "+checkhealth" +qa || true

  echo ""

  dry_run_nvim_plugins
  dry_run_mason
  dry_run_treesitter
}

function main() {
  parse_args "$@"

  if [[ "$SHOW" == true ]]; then
    show_npm_outdated
    exit 0
  fi

  if [[ "$DRY_RUN" == true ]]; then
    run_dry_run
    exit 0
  fi

  if [[ "$DOCTOR" == true ]]; then
    run_doctor
    exit 0
  fi

  [[ "$UPDATE_NODE" == true ]] && update_node
  [[ "$UPDATE_NPM" == true ]] && update_npm_globals
  [[ "$UPDATE_NPM_SELF" == true ]] && update_npm_self

  [[ "$UPDATE_PLUGINS" == true ]] && update_plugins
  [[ "$UPDATE_MASON" == true ]] && update_mason
  [[ "$UPDATE_TREESITTER" == true ]] && update_treesitter

  [[ "$CLEAN_CACHE" == true ]] && npm_clean_cache
  [[ "$HEALTH" == true ]] && check_health
}

main "$@"
