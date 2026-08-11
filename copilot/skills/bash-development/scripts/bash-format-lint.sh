#!/usr/bin/env bash
#-----------------------------------------------------------------------------
# Name: bash-format-lint.sh
# Description: This script formats and lints bash scripts.
# Author: Ernest Duckworth
# Date: 2024-06-19
# Version: 1.0.0
#-----------------------------------------------------------------------------
set -euo pipefail

readonly SHELLFMT="shfmt"
readonly SHELLCHECK="shellcheck"
readonly DEFAULT_EXTENSION=".sh"
readonly DEFAULT_SHFMT_FLAGS=("--simplify" "--write" "--indent" "4" "--binary-next-line" "--case-indent" "--space-redirects")
readonly DEFAULT_SHELLCHECK_FLAGS=("--check-sourced" "--enable=all" "--severity=style")

SEARCH_THINGS=()
FILES=()
EXTENSION="${DEFAULT_EXTENSION}"
SCRIPT_DEBUG="false"

#-----------------------------------------------------------------------------
# Function: main
# Description: The main function that orchestrates the formatting
#              and linting of bash scripts.
# Arguments:
#   $@: Command-line arguments passed to the script
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function main() {
    log_info "Starting bash-format-lint script..."
    parse_args "$@"
    find_files
    fmt
    lint
    log_info "Finished bash-format-lint script..."
    return 0
}

#-----------------------------------------------------------------------------
# Function: parse_args
# Description: Parses command-line arguments and populates the FILES array.
# Globals:
#   FILES: An array to hold the list of files to be processed
# Arguments:
#   $@: Command-line arguments passed to the script
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function parse_args() {
    while [[ $# -gt 0 ]]; do
        case "${1}" in
            -f | --file)
                if [[ $# -lt 2 ]]; then
                    log_error "--file requires an argument."
                    help 1>&2
                    return 1
                elif [[ -z ${2} || ${2} =~ ^- ]]; then
                    log_error "--file requires a non-empty option argument."
                    help 1>&2
                    return 1
                fi
                SEARCH_THINGS+=("${2}")
                shift 2
                ;;
            -e | --extension)
                if [[ $# -lt 2 ]]; then
                    log_error "--extension requires an argument."
                    help 1>&2
                    return 1
                elif [[ -z ${2} ]]; then
                    log_error "--extension requires a non-empty option argument."
                    help 1>&2
                    return 1
                fi
                EXTENSION="${2}"
                shift 2
                ;;
            -d | --directory)
                if [[ $# -lt 2 ]]; then
                    log_error "--directory requires an argument."
                    help 1>&2
                    return 1
                elif [[ -z ${2} || ${2} =~ ^- ]]; then
                    log_error "--directory requires a non-empty option argument."
                    help 1>&2
                    return 1
                fi
                SEARCH_THINGS+=("${2}")
                shift 2
                ;;
            -v | --verbose)
                SCRIPT_DEBUG="true"
                shift
                ;;
            -h | --help)
                help
                exit 0
                ;;
            -*)
                log_error "Unknown option: ${1}"
                help 1>&2
                exit 1
                ;;
            *)
                SEARCH_THINGS+=("${1}")
                shift
                ;;
        esac
    done
    if [[ ${#SEARCH_THINGS[@]} -eq "0" ]]; then
        SEARCH_THINGS+=("${PWD}")
    fi
}

#-----------------------------------------------------------------------------
# Function: help
# Description: Displays usage information for the script.
# Outputs:
#   Writes to STDOUT
#-----------------------------------------------------------------------------
function help() {
    echo "Usage: $0 [options] [files...]"
    echo "Options:"
    echo "  -f, --file <file>  Specify a bash script file to format and lint"
    echo "  -d, --directory <dir>  Specify a directory to format and lint all bash scripts within it"
    echo "  -v, --verbose  Enable verbose logging"
    echo "  -e, --extension <ext>  Specify a file extension to search for (default: .sh)"
    echo "  -h, --help    Show this help message and exit"
}

#-----------------------------------------------------------------------------
# Function: find_files
# Description: Finds files to format and lint based on the SEARCH_THINGS array.
# Globals:
#   SEARCH_THINGS: An array of files and directories to search
# Arguments:
#   None
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function find_files() {
    local thing unique_files
    for thing in "${SEARCH_THINGS[@]}"; do
        add_file_or_dir "${thing}"
    done
    log_debug "Files to process before sorting and deduplication: ${FILES[*]}"
    unique_files="$(printf '%s\n' "${FILES[@]}" | sort -u)"
    IFS=$'\n' read -r -d '' -a FILES < <(printf '%s\n' "${unique_files[@]}" && printf '\0')
    unset IFS
    log_debug "Unique Sorted Files to process: ${FILES[*]}"
}

#-----------------------------------------------------------------------------
# Function: add_file_or_dir
# Description: Adds to files if $1 is file or all discovered files if dir.
# Globals:
#   FILES: An array to hodl the list of files to be processed
# Arguments:
#   $1: The directory or file to be added
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function add_file_or_dir() {
    local thing="${1}"
    if [[ -d ${thing} ]]; then
        discover_bash_scripts "${thing}"
    else
        add_file "${thing}"
    fi
}

#-----------------------------------------------------------------------------
# Function: discover_bash_scripts
# Description: Discovers all bash scripts in the specified directory and adds
#              them to the FILES array.
# Globals:
#   FILES: An array to hold the list of files to be processed
# Arguments:
#   $1: The directory to search for bash scripts
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function discover_bash_scripts() {
    local dir="${1}"
    if [[ ! -d ${dir} ]]; then
        log_error "Directory '${dir}' does not exist."
        help 1>&2
        return 1
    fi
    log_debug "Discovering bash scripts in directory: ${dir}"
    local found file
    found=$(find "${dir}" -type f -name "*${EXTENSION}" -print0)
    while IFS= read -r -d '' file; do
        add_file "${file}"
        log_debug "Discovered bash script: ${file}"
    done < <(printf '%s' "${found}")
}

#-----------------------------------------------------------------------------
# Function: add_file
# Description: Adds a file to the FILES array if it exists.
# Globals:
#   FILES: An array to hold the list of files to be processed
# Arguments:
#   $1: The file to add
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function add_file() {
    local file="${1}"
    if [[ ! -f ${file} ]]; then
        log_error "File '${file}' does not exist."
        help 1>&2
        return 1
    fi
    FILES+=("${file#./}")
    log_debug "Added file: ${file}"
}

#-----------------------------------------------------------------------------
# Function: fmt
# Description: Formats the bash scripts in the FILES array using shfmt.
# Globals:
#   FILES: An array to hold the list of files to be processed
# Arguments:
#   None
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function fmt() {
    local file
    for file in "${FILES[@]}"; do
        log_debug "Formatting file: ${file}"
        if ! "${SHELLFMT}" "${DEFAULT_SHFMT_FLAGS[@]}" "${file}"; then
            log_error "Failed to format file: ${file}"
            return 1
        fi
        log_info "Successfully formatted file: ${file}"
    done
}

#-----------------------------------------------------------------------------
# Function: lint
# Description: Lints the bash scripts in the FILES array using shellcheck.
# Globals:
#   FILES: An array to hold the list of files to be processed
# Arguments:
#   None
# Outputs:
#   Writes to STDOUT and STDERR
# Returns:
#   int: Exit status of the script (0 for success, non-zero for failure)
#-----------------------------------------------------------------------------
function lint() {
    local file
    for file in "${FILES[@]}"; do
        log_debug "Linting file: ${file}"
        if ! "${SHELLCHECK}" "${DEFAULT_SHELLCHECK_FLAGS[@]}" "${file}"; then
            log_error "Failed to lint file: ${file}"
            return 1
        fi
        log_info "Successfully linted file: ${file}"
    done
    return 0
}

#-----------------------------------------------------------------------------
# Logging Functions
# Description: Functions for logging messages with timestamps and severity levels.
# Arguments:
#   $@: The message to log
# Outputs:
#   Writes to STDOUT and STDERR
#-----------------------------------------------------------------------------
function _timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]" || printf "" 2> /dev/null
}

function log_info() {
    local time
    time="$(_timestamp)"
    printf '%s[INFO] %s\n' "${time}" "$*"
}

function log_warn() {
    local time
    time="$(_timestamp)"
    printf '%s[WARN] %s\n' "${time}" "$*" >&2
}

function log_error() {
    local time
    time="$(_timestamp)"
    printf '%s[ERROR] %s\n' "${time}" "$*" >&2
}

function log_debug() {
    local time
    time="$(_timestamp)"
    if [[ ${SCRIPT_DEBUG} == "true" ]]; then
        printf '%s[DEBUG] %s\n' "${time}" "$*" >&2
    fi
}

main "$@"
