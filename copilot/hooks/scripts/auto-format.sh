#!/usr/bin/env bash
set -euo pipefail

function main() {
  command -v jq &>/dev/null || exit 0
  local input tool_name tool_input file_path ext

  input=$(cat)
  tool_name=$(echo "$input" | jq -r '.tool_name // empty')
  tool_input=$(echo "$input" | jq -r '.tool_input // {}')

  if [[ "$tool_name" == "editFiles" || "$tool_name" == "create_file" || "$tool_name" == "replace_string_in_file" ]]; then
    file_path=$(echo "$tool_input" | jq -r '.filePath // .file_path // .files[0] // empty' 2>/dev/null || true)

    if [[ -n "$file_path" && -f "$file_path" ]]; then
      ext="${file_path##*.}"
      format_file "$ext" "$file_path"
    fi
  fi
}

function format_file() {
  local ext="$1"
  local file_path="$2"

  case "$ext" in
    py)
      command -v ruff &>/dev/null && ruff format --quiet "$file_path" 2>/dev/null
      ;;
    go)
      command -v gofmt &>/dev/null && gofmt -w "$file_path" 2>/dev/null
      ;;
    rs)
      command -v rustfmt &>/dev/null && rustfmt --edition 2021 --quiet "$file_path" 2>/dev/null
      ;;
    ts|tsx|js|jsx|json|css|scss|md)
      if command -v npx &>/dev/null && [[ -f "package.json" ]]; then
        npx prettier --write --log-level silent "$file_path" 2>/dev/null
      fi
      ;;
  esac
}

main "$@"
