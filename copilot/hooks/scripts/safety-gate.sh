#!/usr/bin/env bash
set -euo pipefail

readonly DANGEROUS_PATTERNS='rm -rf /|rm -rf \*|DROP TABLE|DROP DATABASE|TRUNCATE|--no-verify|force push|--force|chmod 777|curl.*\| ?sh|wget.*\| ?sh'

function main() {
  command -v jq &>/dev/null || exit 0
  local input tool_name tool_input command

  input=$(cat)
  tool_name=$(echo "$input" | jq -r '.tool_name // empty')
  tool_input=$(echo "$input" | jq -r '.tool_input // {}')

  if [[ "$tool_name" == "runInTerminal" || "$tool_name" == "run_in_terminal" ]]; then
    command=$(echo "$tool_input" | jq -r '.command // empty')
    if echo "$command" | grep -qEi "$DANGEROUS_PATTERNS"; then
      printf '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "Potentially dangerous command detected. Review carefully before approving."}}'
      exit 0
    fi
  fi
}

main "$@"
