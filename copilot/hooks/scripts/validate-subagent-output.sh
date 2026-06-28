#!/usr/bin/env bash
set -euo pipefail

function main() {
  command -v jq &>/dev/null || exit 0
  local input stop_hook_active agent_type transcript_path last_content

  input=$(cat)
  stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active // "false"')

  if [[ "$stop_hook_active" == "true" ]]; then
    printf '{"decision": "allow"}'
    exit 0
  fi

  agent_type=$(echo "$input" | jq -r '.agent_type // "unknown"')
  transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

  if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
    last_content=$(jq -r '[.[] | select(.role == "assistant")] | last | .content // empty' "$transcript_path" 2>/dev/null || true)
    if [[ -z "$last_content" || "$last_content" == "null" ]]; then
      printf '{"decision": "block", "reason": "Subagent %s returned empty. Re-spawn with more specific instructions."}' "$agent_type"
      exit 0
    fi
  fi

  printf '{"decision": "allow"}'
}

main "$@"
