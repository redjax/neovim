#!/usr/bin/env bash

set -Eeuo pipefail

fail() {
  printf '[ERROR] %s\n' "$*" >&2
  exit 2
}

log() {
  printf '[INFO] %s\n' "$*"
}

usage() {
  cat <<'EOF'
Usage: 
  ${0##*/} [OPTIONS]

Options:
  --lint-only                Run only Luacheck.
  --format-only              Run only StyLua.
  --use-lint-cache           Enable Luacheck caching.
  --no-lint-cache            Disable Luacheck caching.
  --fix                      Apply verified formatting changes.
  --check                    Check formatting without modifying source files.
  --strict                   Make warnings and formatting differences blocking.
  --advisory                 Make findings advisory; errors remain blocking.
  --show-diff                Print complete reports instead of previews.
  -h, --help                 Show help.

Environment:
  ROOT                       Repository root; otherwise inferred.
  LINT                       true or false. Default: true.
  FORMAT                     true or false. Default: true.
  USE_LINT_CACHE             true or false. Default: false.
  FIX                        true or false. Default: false.
  LINT_FAIL_ON_FINDINGS      true or false. Default: false.
  FORMAT_FAIL_ON_FINDINGS    true or false. Default: false.
  LINT_SETTINGS_FILE         Default: .luacheckrc.
  FORMAT_SETTINGS_FILE       Default: .stylua.toml, then stylua.toml.
  SCAN_PATHS                 Newline-delimited Git pathspecs. Default: .
  EXCLUDE_PATHS              Newline-delimited wildcard exclusions.
  REPORT_DIR                 Optional report directory.
  SHOW_DIFF                  Print complete reports. Default: false.
  DIFF_PREVIEW_LINES         Maximum preview lines per report. Default: 30.

Requirements:
  Bash 4.3+, git, realpath, mktemp, sed, cmp, diff, wc,
  and the enabled tools: luacheck and/or stylua.

  Install luacheck with: luarocks install luacheck 1.2.0
    Check the latest version at: https://github.com/lunarmodules/luacheck/releases

Exit codes:
  0  Passed or advisory findings.
  1  Blocking findings.
  2  Configuration, tool, or execution error.
EOF
}

LINT="${LINT:-true}"
FORMAT="${FORMAT:-true}"
USE_LINT_CACHE="${USE_LINT_CACHE:-false}"
FIX="${FIX:-false}"
LINT_FAIL_ON_FINDINGS="${LINT_FAIL_ON_FINDINGS:-false}"
FORMAT_FAIL_ON_FINDINGS="${FORMAT_FAIL_ON_FINDINGS:-false}"
SHOW_DIFF="${SHOW_DIFF:-false}"
DIFF_PREVIEW_LINES="${DIFF_PREVIEW_LINES:-30}"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
  --lint-only)
    LINT=true
    FORMAT=false
    ;;
  --format-only)
    LINT=false
    FORMAT=true
    ;;
  --use-lint-cache)
    USE_LINT_CACHE=true
    ;;
  --no-lint-cache)
    USE_LINT_CACHE=false
    ;;
  --fix)
    FIX=true
    ;;
  --check)
    FIX=false
    ;;
  --strict)
    LINT_FAIL_ON_FINDINGS=true
    FORMAT_FAIL_ON_FINDINGS=true
    ;;
  --advisory)
    LINT_FAIL_ON_FINDINGS=false
    FORMAT_FAIL_ON_FINDINGS=false
    ;;
  --show-diff)
    SHOW_DIFF=true
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    fail "Unknown option: $1"
    ;;
  esac

  shift
done

if ((BASH_VERSINFO[0] < 4 || (\
  BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 3))); then
  fail "Bash 4.3 or newer is required."
fi

for name in \
  LINT \
  FORMAT \
  USE_LINT_CACHE \
  FIX \
  LINT_FAIL_ON_FINDINGS \
  FORMAT_FAIL_ON_FINDINGS \
  SHOW_DIFF; do
  case "${!name}" in
  true | false) ;;
  *)
    fail "$name must be true or false."
    ;;
  esac
done

[[ "$DIFF_PREVIEW_LINES" =~ ^[1-9][0-9]*$ ]] ||
  fail "DIFF_PREVIEW_LINES must be a positive integer."

if [[ "$LINT" == false && "$FORMAT" == false ]]; then
  log "Linting and formatting are disabled. Nothing to run."
  exit 0
fi

for dependency in git realpath mktemp sed cmp diff wc; do
  command -v "$dependency" >/dev/null 2>&1 ||
    fail "Required command is missing: $dependency"
done

SCRIPT_DIR="$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd
)"

if [[ -z "${ROOT:-}" ]]; then
  ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)" ||
    fail "Cannot determine the repository root."
fi

ROOT="$(realpath -e -- "$ROOT")" ||
  fail "ROOT does not exist."

cd -- "$ROOT"

if [[ "$LINT" == true ]]; then
  command -v luacheck >/dev/null 2>&1 ||
    fail "Install luacheck and add it to PATH. Install with LuaRocks: luarocks install luacheck 1.2.0"
fi

if [[ "$FORMAT" == true ]]; then
  command -v stylua >/dev/null 2>&1 ||
    fail "Install stylua and add it to PATH."
fi

resolve_config() {
  local requested="$1"
  local resolved

  [[ "$requested" != /* ]] ||
    fail "Configuration must be repository-relative: $requested"

  resolved="$(realpath -e -- "$ROOT/$requested")" ||
    fail "Configuration does not exist: $requested"

  [[ -f "$resolved" && "$resolved" == "$ROOT/"* ]] ||
    fail "Configuration must be a file inside the repository: $requested"

  printf '%s\n' "$resolved"
}

lint_config=""
format_config=""

if [[ "$LINT" == true ]]; then
  lint_config="$(
    resolve_config "${LINT_SETTINGS_FILE:-.luacheckrc}"
  )" || exit 2
fi

if [[ "$FORMAT" == true ]]; then
  requested="${FORMAT_SETTINGS_FILE:-}"

  if [[ -z "$requested" ]]; then
    if [[ -f .stylua.toml ]]; then
      requested=.stylua.toml
    else
      requested=stylua.toml
    fi
  fi

  format_config="$(resolve_config "$requested")" || exit 2
fi

TMP="$(mktemp -d)"

# shellcheck disable=SC2329
cleanup() {
  rm -rf -- "$TMP"
}

# shellcheck disable=SC2329
unexpected_error() {
  trap - ERR
  printf '[ERROR] Unexpected failure near line %s.\n' "$1" >&2
  exit 2
}

trap cleanup EXIT
trap 'unexpected_error "$LINENO"' ERR

if [[ -z "${REPORT_DIR:-}" ]]; then
  mkdir -p -- "$ROOT/.reports/lua"
  REPORT_DIR="$(mktemp -d "$ROOT/.reports/lua/run.XXXXXXXX")"
fi

mkdir -p -- "$REPORT_DIR"
REPORT_DIR="$(realpath -e -- "$REPORT_DIR")"

print_report() {
  local report="$1"
  local line_count

  [[ -s "$report" ]] || return 0

  if [[ "$SHOW_DIFF" == true ]]; then
    sed 's/^/| /' "$report"
  else
    line_count="$(wc -l <"$report")"

    sed -n "1,${DIFF_PREVIEW_LINES}{
      s/^/| /
      p
    }" "$report"

    if ((line_count > DIFF_PREVIEW_LINES)); then
      log "Remaining report output omitted from the terminal."
    fi
  fi

  printf '[INFO] Full report: %s\n' "$report"
  printf '[INFO] View interactively: less -R %q\n' "$report"
}

read_lines() {
  local -n destination="$1"
  local value="$2"
  local line

  destination=()

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    [[ -n "$line" ]] && destination+=("$line")
  done <<<"$value"

  return 0
}

declare -a paths=()
declare -a excludes=()
declare -a files=()
declare -a lint_files=()

read_lines paths "${SCAN_PATHS:-.}"
read_lines excludes "${EXCLUDE_PATHS:-}"

if [[ "${#paths[@]}" -eq 0 ]]; then
  paths=(".")
fi

git ls-files --stage -z -- "${paths[@]}" >"$TMP/tracked"

while IFS= read -r -d '' record; do
  metadata="${record%%$'\t'*}"
  file="${record#*$'\t'}"

  read -r mode _object stage <<<"$metadata"

  [[ "$stage" == 0 ]] || continue
  [[ "$mode" == 100644 || "$mode" == 100755 ]] || continue
  [[ "$file" == *.lua ]] || continue
  [[ -f "$file" && ! -L "$file" ]] || continue

  resolved="$(realpath -e -- "$file")"
  [[ "$resolved" == "$ROOT/"* ]] || continue

  excluded=false

  for pattern in "${excludes[@]}"; do
    # shellcheck disable=SC2053
    if [[ "$file" == $pattern ]]; then
      excluded=true
      break
    fi
  done

  if [[ "$excluded" == false ]]; then
    files+=("$file")
    lint_files+=("./$file")
  fi
done <"$TMP/tracked"

log "Repository: $ROOT"
log "Selected Lua files: ${#files[@]}"
log "Reports: $REPORT_DIR"

overall_status=0

if [[ "$LINT" == true ]]; then
  lint_report="$REPORT_DIR/luacheck.txt"

  printf 'Settings: %s\nSelected files: %s\nCache: %s\n' \
    "$lint_config" \
    "${#files[@]}" \
    "$USE_LINT_CACHE" >"$lint_report"

  if [[ "${#files[@]}" -gt 0 ]]; then
    cache_option=--no-cache

    if [[ "$USE_LINT_CACHE" == true ]]; then
      cache_option=--cache
    fi

    log "Running Luacheck."

    status=0

    luacheck \
      --config "$lint_config" \
      --no-default-config \
      "$cache_option" \
      --no-color \
      --codes \
      --formatter plain \
      "${lint_files[@]}" >"$TMP/lint-output" 2>&1 || status=$?

    {
      printf '\n'
      cat -- "$TMP/lint-output"
      printf '\nLuacheck exit code: %s\n' "$status"
    } >>"$lint_report"

    print_report "$lint_report"

    case "$status" in
    0)
      log "Luacheck passed."
      ;;
    1)
      if [[ "$LINT_FAIL_ON_FINDINGS" == true ]]; then
        log "Luacheck reported blocking warnings."
        overall_status=1
      else
        log "Luacheck reported advisory warnings."
      fi
      ;;
    *)
      printf '[ERROR] Luacheck failed with exit code %s.\n' \
        "$status" >&2
      overall_status=2
      ;;
    esac
  else
    printf 'No matching tracked Lua files.\n' >>"$lint_report"
    log "No matching tracked Lua files for linting."
  fi
fi

if [[ "$FORMAT" == true ]]; then
  format_report="$REPORT_DIR/stylua.txt"
  diff_file="$REPORT_DIR/format.diff"
  patch_file="$REPORT_DIR/format.patch"

  printf 'Settings: %s\nSelected files: %s\nFix: %s\n' \
    "$format_config" \
    "${#files[@]}" \
    "$FIX" >"$format_report"

  : >"$diff_file"
  rm -f -- "$patch_file"

  declare -a changed_files=()
  declare -a formatted_files=()

  formatter_errors=0
  index=0

  log "Running StyLua."

  for file in "${files[@]}"; do
    index=$((index + 1))
    formatted="$TMP/formatted-$index"
    diagnostics="$TMP/diagnostics-$index"

    status=0

    # shellcheck disable=SC2094
    stylua \
      --config-path "$format_config" \
      --no-editorconfig \
      --verify \
      --stdin-filepath "$file" \
      - <"$file" >"$formatted" 2>"$diagnostics" || status=$?

    if [[ -s "$diagnostics" ]]; then
      {
        printf '\n=== %s: diagnostics ===\n' "$file"
        cat -- "$diagnostics"
      } >>"$format_report"
    fi

    if [[ "$status" -ne 0 ]]; then
      formatter_errors=$((formatter_errors + 1))

      printf 'Formatter error: %s; exit code: %s\n' \
        "$file" "$status" >>"$format_report"

      continue
    fi

    compare_status=0
    cmp -s -- "$file" "$formatted" || compare_status=$?

    case "$compare_status" in
    0)
      printf 'Formatted correctly: %s\n' "$file" >>"$format_report"
      continue
      ;;
    1) ;;
    *)
      fail "Could not compare formatted output: $file"
      ;;
    esac

    changed_files+=("$file")
    formatted_files+=("$formatted")

    printf 'Formatting differences: %s\n' "$file" >>"$format_report"

    diff_status=0

    diff \
      -u \
      --label "a/$file" \
      --label "b/$file" \
      -- "$file" "$formatted" >"$TMP/current-diff" || diff_status=$?

    [[ "$diff_status" -le 1 ]] ||
      fail "Could not generate formatting diff: $file"

    cat -- "$TMP/current-diff" >>"$diff_file"
  done

  fixed=0

  if [[ "$FIX" == true && "$formatter_errors" -eq 0 ]]; then
    for index in "${!changed_files[@]}"; do
      cat -- "${formatted_files[$index]}" >"${changed_files[$index]}"
      fixed=$((fixed + 1))
    done

    if [[ "$fixed" -gt 0 ]]; then
      : >"$patch_file"

      for file in "${changed_files[@]}"; do
        git --no-pager diff \
          --no-ext-diff \
          --binary \
          --full-index \
          -- "./$file" >>"$patch_file"
      done

      log "Formatting patch: $patch_file"
    fi
  elif [[ "$FIX" == true && "$formatter_errors" -gt 0 ]]; then
    log "No formatting fixes applied because formatter errors occurred."
  fi

  {
    printf '\nFiles requiring formatting: %s\n' "${#changed_files[@]}"
    printf 'Files fixed: %s\n' "$fixed"
    printf 'Files with formatter errors: %s\n' "$formatter_errors"
  } >>"$format_report"

  if [[ "$formatter_errors" -gt 0 ]]; then
    print_report "$format_report"
    overall_status=2
  fi

  if [[ -s "$diff_file" ]]; then
    log "Formatting differences:"
    print_report "$diff_file"
  fi

  log "Files requiring formatting: ${#changed_files[@]}"
  log "Files fixed: $fixed"
  log "Files with formatter errors: $formatter_errors"
  log "StyLua report: $format_report"

  if [[ "$formatter_errors" -eq 0 &&
    "$FIX" == false &&
    "${#changed_files[@]}" -gt 0 ]]; then
    if [[ "$FORMAT_FAIL_ON_FINDINGS" == true ]]; then
      log "Formatting differences are blocking."

      if [[ "$overall_status" -eq 0 ]]; then
        overall_status=1
      fi
    else
      log "Formatting differences are advisory."
    fi
  fi
fi

log "Reports: $REPORT_DIR"
log "Overall exit code: $overall_status"

exit "$overall_status"
