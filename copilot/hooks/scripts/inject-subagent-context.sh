#!/usr/bin/env bash
set -euo pipefail

function main() {
  command -v jq &>/dev/null || exit 0
  local input agent_type agent_id cwd context_parts additional_context

  input=$(cat)
  agent_type=$(echo "$input" | jq -r '.agent_type // "unknown"')
  agent_id=$(echo "$input" | jq -r '.agent_id // empty')
  cwd=$(echo "$input" | jq -r '.cwd // empty')

  context_parts=()
  context_parts+=("You are running as subagent '${agent_type}' (id: ${agent_id}).")

  if [[ -n "$cwd" ]]; then
    gather_git_context "$cwd"
    gather_instructions_context "$cwd"
    gather_domain_instructions "$cwd"
  fi

  context_parts+=("Return concrete, actionable output. If you cannot complete the task, explain exactly what is missing so the caller can provide it.")

  additional_context=$(printf "%s " "${context_parts[@]}")
  jq -n --arg ctx "$additional_context" '{
    "hookSpecificOutput": {
      "hookEventName": "SubagentStart",
      "additionalContext": $ctx
    }
  }'
}

function gather_git_context() {
  local cwd="$1"
  local branch

  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  context_parts+=("Git branch: ${branch}.")
}

function gather_instructions_context() {
  local cwd="$1"
  local instructions_file

  for instructions_file in ".github/copilot-instructions.md" "AGENTS.md" "CLAUDE.md"; do
    if [[ -f "${cwd}/${instructions_file}" ]]; then
      context_parts+=("Project instructions found: ${instructions_file}")
      break
    fi
  done
}

function gather_domain_instructions() {
  local cwd="$1"
  local instructions_dir files

  instructions_dir="${cwd}/.github/instructions"
  if [[ -d "$instructions_dir" ]]; then
    files=$(find "$instructions_dir" -maxdepth 1 -name "*.instructions.md" -exec basename {} \; 2>/dev/null | paste -sd ',' -)
    if [[ -n "$files" ]]; then
      context_parts+=("Domain instruction files: ${files}. Read the relevant one before working in that area.")
    fi
  fi
}

main "$@"
