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
  --lint-only                   Run only ShellCheck.
  --format-only                 Run only shfmt.
  --fix                         Apply formatting changes.
  --check                       Check formatting without modifying source files.
  --strict                      Make findings blocking.
  --advisory                    Make findings advisory.
  --show-diff                   Print complete reports instead of previews.
  -h, --help                    Show help.

Environment:
  ROOT                          Repository root. Inferred if undeclared
  LINT                          true or false. Default: true.
  FORMAT                        true or false. Default: true.
  REPORT_DIR                    Optional report directory.
  SHOW_DIFF                     Print complete reports. Default: false.
  DIFF_PREVIEW_LINES            Maximum preview lines per report. Default: 30.

  SHELLCHECK_SEVERITY           Default: error.
  SHELLCHECK_SCAN_PATH          Default: .
  SHELLCHECK_INCLUDE_PATTERNS   Default: *.sh,*.bash,*.bats
  SHELLCHECK_EXCLUDE_PATHS      Comma-separated excluded path fragments.
  SHELLCHECK_FAIL_ON_FINDINGS   Default: true.

  SHELLFMT_SCAN_PATH            Default: .
  SHELLFMT_INCLUDE_PATTERNS     Default: *.sh,*.bash,*.bats
  SHELLFMT_EXCLUDE_PATHS        Comma-separated excluded path fragments.
  SHELLFMT_CONFIG_PATH          Optional options file; one argument per line.
  SHELLFMT_MODE                 check or write. Default: check.
  SHELLFMT_FAIL_ON_FINDINGS     Default: true.

Requirements:
  Bash, git, realpath, mktemp, find, sed, wc,
  and the enabled tools: shellcheck and/or shfmt.

Exit codes:
  0  Passed or advisory findings.
  1  Blocking findings.
  2  Configuration, tool, or execution error.
EOF
}

LINT="${LINT:-true}"
FORMAT="${FORMAT:-true}"
SHOW_DIFF="${SHOW_DIFF:-false}"
DIFF_PREVIEW_LINES="${DIFF_PREVIEW_LINES:-30}"

SHELLCHECK_SEVERITY="${SHELLCHECK_SEVERITY:-error}"
SHELLCHECK_SCAN_PATH="${SHELLCHECK_SCAN_PATH:-.}"
SHELLCHECK_INCLUDE_PATTERNS="${SHELLCHECK_INCLUDE_PATTERNS:-*.sh,*.bash,*.bats}"
SHELLCHECK_EXCLUDE_PATHS="${SHELLCHECK_EXCLUDE_PATHS:-.git,node_modules,vendor,dist,build,.terraform}"
SHELLCHECK_FAIL_ON_FINDINGS="${SHELLCHECK_FAIL_ON_FINDINGS:-true}"

SHELLFMT_SCAN_PATH="${SHELLFMT_SCAN_PATH:-.}"
SHELLFMT_INCLUDE_PATTERNS="${SHELLFMT_INCLUDE_PATTERNS:-*.sh,*.bash,*.bats}"
SHELLFMT_EXCLUDE_PATHS="${SHELLFMT_EXCLUDE_PATHS:-.git,node_modules,vendor,dist,build,.terraform}"
SHELLFMT_CONFIG_PATH="${SHELLFMT_CONFIG_PATH:-}"
SHELLFMT_MODE="${SHELLFMT_MODE:-check}"
SHELLFMT_FAIL_ON_FINDINGS="${SHELLFMT_FAIL_ON_FINDINGS:-true}"

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
  --fix)
    SHELLFMT_MODE="write"
    ;;
  --check)
    SHELLFMT_MODE=check
    ;;
  --strict)
    SHELLCHECK_FAIL_ON_FINDINGS=true
    SHELLFMT_FAIL_ON_FINDINGS=true
    ;;
  --advisory)
    SHELLCHECK_FAIL_ON_FINDINGS=false
    SHELLFMT_FAIL_ON_FINDINGS=false
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

for name in \
  LINT \
  FORMAT \
  SHOW_DIFF \
  SHELLCHECK_FAIL_ON_FINDINGS \
  SHELLFMT_FAIL_ON_FINDINGS; do
  case "${!name}" in
  true | false) ;;
  *)
    fail "$name must be true or false."
    ;;
  esac
done

[[ "$DIFF_PREVIEW_LINES" =~ ^[1-9][0-9]*$ ]] ||
  fail "DIFF_PREVIEW_LINES must be a positive integer."

case "$SHELLFMT_MODE" in
check | write) ;;
*)
  fail "SHELLFMT_MODE must be check or write."
  ;;
esac

case "$SHELLCHECK_SEVERITY" in
error | warning | info | style) ;;
*)
  fail "SHELLCHECK_SEVERITY must be error, warning, info, or style."
  ;;
esac

if [[ "$LINT" == false && "$FORMAT" == false ]]; then
  log "Linting and formatting are disabled. Nothing to run."
  exit 0
fi

for dependency in git realpath mktemp find sed wc; do
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
  command -v shellcheck >/dev/null 2>&1 ||
    fail "Install shellcheck and add it to PATH."

  [[ -e "$SHELLCHECK_SCAN_PATH" ]] ||
    fail "ShellCheck scan path does not exist: $SHELLCHECK_SCAN_PATH"
fi

if [[ "$FORMAT" == true ]]; then
  command -v shfmt >/dev/null 2>&1 ||
    fail "Install shfmt and add it to PATH."

  [[ -e "$SHELLFMT_SCAN_PATH" ]] ||
    fail "shellfmt scan path does not exist: $SHELLFMT_SCAN_PATH"

  if [[ -n "$SHELLFMT_CONFIG_PATH" ]]; then
    [[ -f "$SHELLFMT_CONFIG_PATH" ]] ||
      fail "shellfmt options file does not exist: $SHELLFMT_CONFIG_PATH"
  fi
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
  mkdir -p -- "$ROOT/.reports/shell"
  REPORT_DIR="$(mktemp -d "$ROOT/.reports/shell/run.XXXXXXXX")"
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

select_files() {
  local scan="$1"
  local includes="$2"
  local exclusions="$3"
  local output="$4"
  local file name pattern excluded fragment
  local -a include_patterns=()
  local -a exclude_paths=()

  # Normalize directory scan roots so exclusions also work for "scripts"
  # rather than only "./scripts".
  scan="$(realpath -e -- "$scan")"

  IFS=',' read -r -a include_patterns <<<"$includes"
  IFS=',' read -r -a exclude_paths <<<"$exclusions"

  find "$scan" -type f -print0 >"$TMP/found" ||
    fail "File discovery failed for: $scan"

  : >"$output"

  while IFS= read -r -d '' file; do
    if [[ "$file" == "$ROOT/"* ]]; then
      file="./${file#"$ROOT/"}"
    fi

    excluded=false

    for fragment in "${exclude_paths[@]}"; do
      fragment="${fragment#"${fragment%%[![:space:]]*}"}"
      fragment="${fragment%"${fragment##*[![:space:]]}"}"

      [[ -n "$fragment" ]] || continue

      if [[ "$file" == *"/$fragment/"* ||
        "$file" == *"/$fragment" ]]; then
        excluded=true
        break
      fi
    done

    [[ "$excluded" == false ]] || continue

    name="${file##*/}"

    for pattern in "${include_patterns[@]}"; do
      pattern="${pattern#"${pattern%%[![:space:]]*}"}"
      pattern="${pattern%"${pattern##*[![:space:]]}"}"

      # shellcheck disable=SC2053
      if [[ -n "$pattern" && "$name" == $pattern ]]; then
        printf '%s\0' "$file" >>"$output"
        break
      fi
    done
  done <"$TMP/found"
}

overall_status=0

handle_status() {
  local tool="$1"
  local status="$2"
  local blocking="$3"

  case "$status" in
  0)
    log "$tool passed."
    ;;
  1)
    if [[ "$blocking" == true ]]; then
      log "$tool reported blocking findings."

      if [[ "$overall_status" -eq 0 ]]; then
        overall_status=1
      fi
    else
      log "$tool reported advisory findings."
    fi
    ;;
  *)
    printf '[ERROR] %s failed with exit code %s.\n' \
      "$tool" "$status" >&2
    overall_status=2
    ;;
  esac
}

log "Repository: $ROOT"
log "Reports: $REPORT_DIR"

if [[ "$LINT" == true ]]; then
  select_files \
    "$SHELLCHECK_SCAN_PATH" \
    "$SHELLCHECK_INCLUDE_PATTERNS" \
    "$SHELLCHECK_EXCLUDE_PATHS" \
    "$TMP/lint-files"

  lint_files=()

  while IFS= read -r -d '' file; do
    lint_files+=("$file")
  done <"$TMP/lint-files"

  lint_report="$REPORT_DIR/shellcheck.txt"
  : >"$lint_report"

  log "Selected ShellCheck files: ${#lint_files[@]}"

  if [[ "${#lint_files[@]}" -gt 0 ]]; then
    status=0

    shellcheck \
      --format gcc \
      "--severity=$SHELLCHECK_SEVERITY" \
      --external-sources \
      "${lint_files[@]}" >"$lint_report" 2>&1 || status=$?

    print_report "$lint_report"
    handle_status "ShellCheck" "$status" "$SHELLCHECK_FAIL_ON_FINDINGS"
  else
    log "No matching files for ShellCheck."
  fi
fi

if [[ "$FORMAT" == true ]]; then
  select_files \
    "$SHELLFMT_SCAN_PATH" \
    "$SHELLFMT_INCLUDE_PATTERNS" \
    "$SHELLFMT_EXCLUDE_PATHS" \
    "$TMP/format-files"

  format_files=()

  while IFS= read -r -d '' file; do
    format_files+=("$file")
  done <"$TMP/format-files"

  options=()

  if [[ -n "$SHELLFMT_CONFIG_PATH" ]]; then
    while IFS= read -r option || [[ -n "$option" ]]; do
      option="${option%$'\r'}"
      option="${option#"${option%%[![:space:]]*}"}"
      option="${option%"${option##*[![:space:]]}"}"

      [[ -n "$option" && "$option" != \#* ]] || continue

      options+=("$option")
    done <"$SHELLFMT_CONFIG_PATH"
  fi

  format_report="$REPORT_DIR/shellfmt.report"
  : >"$format_report"

  log "Selected shfmt files: ${#format_files[@]}"

  if [[ "${#format_files[@]}" -gt 0 ]]; then
    status=0

    if [[ "$SHELLFMT_MODE" == check ]]; then
      shfmt \
        "${options[@]}" \
        -d \
        "${format_files[@]}" >"$format_report" 2>&1 || status=$?

      print_report "$format_report"
      handle_status "shfmt" "$status" "$SHELLFMT_FAIL_ON_FINDINGS"
    else
      log "Fix mode modifies selected working-tree files."

      shfmt \
        "${options[@]}" \
        -l \
        "${format_files[@]}" >"$format_report" 2>&1 || status=$?

      print_report "$format_report"

      if [[ "$status" -ne 0 ]]; then
        printf '[ERROR] shfmt preflight failed with exit code %s.\n' \
          "$status" >&2
        overall_status=2
      elif [[ -s "$format_report" ]]; then
        write_status=0

        shfmt \
          "${options[@]}" \
          -w \
          "${format_files[@]}" \
          >"$TMP/write-output" 2>&1 || write_status=$?

        cat -- "$TMP/write-output" >>"$format_report"

        if [[ -s "$TMP/write-output" ]]; then
          print_report "$TMP/write-output"
        fi

        if [[ "$write_status" -ne 0 ]]; then
          printf '[ERROR] shfmt could not apply all fixes. See %s\n' \
            "$format_report" >&2
          overall_status=2
        else
          log "Formatting fixes applied."
        fi
      else
        log "No formatting fixes required."
      fi
    fi
  else
    log "No matching files for shfmt."
  fi
fi

log "Reports: $REPORT_DIR"
log "Overall exit code: $overall_status"

exit "$overall_status"
