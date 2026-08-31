#!/usr/bin/env bash
# --- 1. file-level doc comment ---
#
# 18-bash-fixture.sh — Bash syntax-highlighting fixture.
#
# Exercises the full token surface: keywords, declarations, expansions,
# literals and operators. Sections are ordered identically across every
# fixture in this directory.

set -euo pipefail

# --- 2. imports / modules ---
# shellcheck source=/dev/null
[[ -r /etc/profile ]] && source /etc/profile
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# --- 3. constants & statics ---
readonly MAX_RETRIES=0x1F
readonly THRESHOLD=1250
readonly DEFAULT_PREFIX='hello'
readonly TOKEN_RE='^[a-z_][a-zA-Z0-9_]*(\.[a-zA-Z0-9_]+)*$'
declare -i counter=0
declare -a NAMES=("alpha" "" "gamma")
declare -A CONFIG=([prefix]="$DEFAULT_PREFIX" [count]=2 [active]=true)
export VERBOSE="${VERBOSE:-true}"

# --- 4. type declarations (bash has none; declare attributes stand in) ---
declare -r MODE_IDLE=0
declare -r MODE_RUN=1
declare -r MODE_HALT=2
declare -n config_ref=CONFIG

# --- 5. decorated / annotated declaration ---
# shellcheck disable=SC2317
cleanup() {
  local -ri code=$?
  printf 'cleanup: %d\n' "$code" >&2
  return "$code"
}
trap cleanup EXIT INT TERM

# --- 6. generic function with constraints (nameref stands in for generics) ---
sum_into() {
  local -n out_ref="$1"
  shift
  local value
  out_ref=0
  for value in "$@"; do
    (( out_ref += value ))
  done
}

# --- 7. parameters, control flow, operators ---
process() {
  local prefix="${1:?prefix required}"
  local limit="${2:-8}"
  shift 2
  local -a names=("$@")
  local -i count=0
  local index name

  for index in "${!names[@]}"; do
    name="${names[index]}"
    if (( limit > 0 && index >= limit )); then
      break
    elif [[ -z "$name" || "$VERBOSE" != 'true' ]]; then
      continue
    fi
    (( count += (index & 0x0F) | (1 << 2) ))
    (( count -= index >> 1 ))
  done

  case "${CONFIG[count]}" in
    1 | 2) (( count *= 2 )) ;;
    [3-9]) (( count /= 2 )) ;;
    *) count=0 ;;
  esac

  while (( count > THRESHOLD )); do
    (( count /= 2 ))
  done

  until (( count >= 0 )); do
    (( count++ ))
  done

  printf '%s, %s x%d\n' "$prefix" "${names[0]:-world}" "$count"
  return 0
}

# --- 8. strings, numbers, escapes, regex ---
literals() {
  local raw='raw \n stays literal'
  local quoted="tab:\tnewline:\nprefix:${DEFAULT_PREFIX}"
  local hex=0x1F bin=$(( 2#1011 )) octal=0755 sci='6.022e23'
  local flags=$(( 0xA6 ^ 0x0F ))
  local upper="${DEFAULT_PREFIX^^}" tail="${SCRIPT_DIR##*/}"

  printf 'tab:\tnewline:\nunicode:\u2713\n'
  printf '%s|%s|%d|%d|%d|%s|%d|%s|%s\n' \
    "$raw" "$quoted" "$hex" "$bin" "$octal" "$sci" "$flags" "$upper" "$tail"

  if [[ "alpha.beta" =~ $TOKEN_RE ]]; then
    printf 'matched: %s\n' "${BASH_REMATCH[0]}"
  fi

  cat <<'EOF'
heredoc: literal $NOT_EXPANDED and \n untouched
EOF

  cat <<EOF
heredoc: expanded ${DEFAULT_PREFIX} and ${counter}
EOF
  # TODO: cover coproc and process substitution.
}

# --- 9. entrypoint ---
main() {
  local -i total=0
  local -a lines=()

  literals
  sum_into total 3 5 8
  mapfile -t lines < <(process "$DEFAULT_PREFIX" "$MAX_RETRIES" "${NAMES[@]}")
  counter=$(( counter + total ))

  printf 'total=%d counter=%d modes=%d/%d/%d ref=%s out=%s\n' \
    "$total" "$counter" "$MODE_IDLE" "$MODE_RUN" "$MODE_HALT" \
    "${config_ref[prefix]}" "${lines[*]}"
}

main "$@"
