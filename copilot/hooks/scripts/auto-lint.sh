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

    if [[ -n "$file_path" ]]; then
      ext="${file_path##*.}"
      lint_file "$ext" "$file_path"
    fi
  fi
}

function lint_file() {
  local ext="$1"
  local file_path="$2"
  local lint_output dir

  case "$ext" in
    py)
      if command -v ruff &>/dev/null; then
        lint_output=$(ruff check --select E,W "$file_path" 2>&1 || true)
        if [[ -n "$lint_output" ]]; then
          emit_context "Lint issues in ${file_path}:\n${lint_output}\nRun ruff check --fix to auto-fix."
        fi
      fi
      ;;
    go)
      if command -v golangci-lint &>/dev/null; then
        lint_output=$(golangci-lint run --path-prefix="" "$file_path" 2>&1 || true)
        if [[ -n "$lint_output" ]]; then
          emit_context "Lint issues in ${file_path}:\n${lint_output}"
        fi
      elif command -v go &>/dev/null; then
        lint_output=$(go vet "$file_path" 2>&1 || true)
        if [[ -n "$lint_output" ]]; then
          emit_context "go vet issues in ${file_path}:\n${lint_output}"
        fi
      fi
      ;;
    rs)
      if command -v cargo &>/dev/null; then
        dir=$(dirname "$file_path")
        while [[ "$dir" != "/" && ! -f "${dir}/Cargo.toml" ]]; do
          dir=$(dirname "$dir")
        done
        if [[ -f "${dir}/Cargo.toml" ]]; then
          lint_output=$(cargo clippy --manifest-path "${dir}/Cargo.toml" --message-format short 2>&1 | grep -i "warning\|error" || true)
          if [[ -n "$lint_output" ]]; then
            emit_context "Clippy issues:\n${lint_output}"
          fi
        fi
      fi
      ;;
    ts|tsx|js|jsx)
      if command -v npx &>/dev/null && [[ -f "package.json" ]]; then
        lint_output=$(npx eslint --no-error-on-unmatched-pattern "$file_path" 2>&1 || true)
        if echo "$lint_output" | grep -q "error\|warning"; then
          emit_context "Lint issues in ${file_path}:\n${lint_output}"
        fi
      fi
      ;;
  esac
}

function emit_context() {
  local message="$1"
  jq -n --arg ctx "$message" '{
    "hookSpecificOutput": {
      "hookEventName": "PostToolUse",
      "additionalContext": $ctx
    }
  }'
  exit 0
}

main "$@"
