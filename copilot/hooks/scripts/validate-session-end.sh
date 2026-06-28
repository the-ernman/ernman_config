#!/usr/bin/env bash
set -euo pipefail

function main() {
  command -v jq &>/dev/null || exit 0
  local input stop_hook_active transcript_path

  input=$(cat)
  stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active // "false"')

  if [[ "$stop_hook_active" == "true" ]]; then
    exit 0
  fi

  transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

  if [[ -z "$transcript_path" || ! -f "$transcript_path" ]]; then
    exit 0
  fi

  if grep -qi "subagent\|runSubagent\|run_subagent" "$transcript_path" 2>/dev/null; then
    exit 0
  fi

  jq -n '{
    "hookSpecificOutput": {
      "hookEventName": "Stop",
      "decision": "block",
      "reason": "No subagent calls detected. You MUST delegate via runSubagent."
    }
  }'
}

main "$@"
