---
name: bash-development
description: Bash/shell scripting best practices. Activate when working with .sh files, shell scripts, or bash automation.
---

# Bash Development

## Script Structure

Every script follows this layout:

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"

function main() {
  :
}

function _timestamp() { command -v date &> /dev/null && date '+[%Y-%m-%d %H:%M:%S]'; }
function log_info()   { printf '%s[INFO]  %s\n' "$(_timestamp)" "$*"; }
function log_warn()   { printf '%s[WARN]  %s\n' "$(_timestamp)" "$*" >&2; }
function log_error()  { printf '%s[ERROR] %s\n' "$(_timestamp)" "$*" >&2; }
function log_fatal()  { printf '%s[FATAL] %s\n' "$(_timestamp)" "$*" >&2; exit 1; }
function usage() {:;}
function parse_args() {:;}

main "$@"
```

- `main "$@"` is ALWAYS the last line
- `main` contains no logic, always broken up into helper functions
- NO LOGIC outside of functions; global scope only for constants and function definitions
- Helper functions before utility functions; utility functions (logging, usage) at the very end

## Loops and Conditionals

- Use `[[ ]]` for conditionals, with `&&`/`||` for control flow
- Use `case` for multi-branch conditions, especially in argument parsing
- Avoid `if` statements when a simple `&&`/`||` can achieve the same result more cleanly
- Always quote variables in conditionals: `[[ -f "$file" ]]`
- Use `(( ))` for arithmetic conditions: `if (( count > 10 )); then ... fi`
- `then` and `do` should be on a new line for readability

## Argument Parsing

Preferred pattern — `while` + `case` with `shift`:

```bash
function parse_args() {
  local verbose=false
  local output_dir=""

  while [[ $# -gt 0 ]];
  do
    case "$1" in
      --)           shift; break ;;
      -*)           log_fatal "Unknown option: $1" ;;
      *)            break ;;
    esac
    shift
  done
  readonly VERBOSE="$verbose" OUTPUT_DIR="$output_dir"
}
```

- Use `${2:?'msg'}` to enforce required option values
- Support `--` to end option parsing
- Positional args accessed after the loop via `"$@"`

## Naming

- Exported/env vars: `UPPER_SNAKE_CASE`
- Local vars: `lower_snake_case` with `local` keyword
- Functions: `lower_snake_case`, verb-noun pattern, always prefix with `function` keyword for clarity
- Script filenames: `kebab-case.sh`

## Rules

- Quote all expansions: `"$var"`, `"${array[@]}"`
- `[[ ]]` over `[ ]`
- `$(command)` over backticks
- `local` for all function variables
- `trap` for cleanup (EXIT, ERR, INT)
- No `eval`; no unquoted expansions
- `command -v` to check tool availability (not `which`)
- Use `set -euo pipefail` for safety
- `readonly` for constants
- Use functions for logical organization; avoid global code outside `main()`
- Use `mktemp` for temp files/directories; never hardcode `/tmp`

## Tooling

- `shellcheck`: mandatory, zero warnings
- `shfmt`: indent=4, binary-next-line

## Anti-patterns

- No `cd` without `|| exit` or subshell
- No parsing `ls` output
- No useless use of `cat`
- No unquoted `$@` or `$*`
- No hardcoded `/tmp` paths (use `mktemp`)
- No scripts without `main()`
- Using `$?` checks rather in inline with `if` or `&&`/`||` constructs
