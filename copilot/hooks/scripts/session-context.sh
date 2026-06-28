#!/usr/bin/env bash
set -euo pipefail

function main() {
  command -v jq &>/dev/null || exit 0
  local input cwd context_parts branch additional_context

  input=$(cat)
  cwd=$(echo "$input" | jq -r '.cwd // empty')
  context_parts=()

  if [[ -n "$cwd" ]]; then
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    context_parts+=("Branch: ${branch}")
    detect_project_type "$cwd"
  fi

  if [[ ${#context_parts[@]} -gt 0 ]]; then
    additional_context=$(IFS='; '; echo "${context_parts[*]}")
    jq -n --arg ctx "$additional_context" '{
      "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": $ctx
      }
    }'
  fi
}

function detect_project_type() {
  local cwd="$1"

  if [[ -f "${cwd}/pyproject.toml" ]]; then
    context_parts+=("Python project (uv/pytest)")
  elif [[ -f "${cwd}/Cargo.toml" ]]; then
    context_parts+=("Rust project (cargo)")
  elif [[ -f "${cwd}/go.mod" ]]; then
    context_parts+=("Go project")
  elif [[ -f "${cwd}/package.json" ]]; then
    context_parts+=("Node.js project")
  fi
}

main "$@"
