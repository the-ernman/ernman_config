#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOME_DIR="${HOME}"
readonly VALID_COMPONENTS=(bash vim vi neovim tmux copilot omp ghostty vscode zed)
readonly FILES=(
    "bash/.bashrc"
    "bash/.bash_profile"
    "bash/.bash_aliases"
    "vim/.vimrc"
    "vi/.virc"
    "neovim/init.vim"
    "tmux/.tmux.conf"
)
ENABLED_COMPONENTS=()

function main() {
    parse_args "$@"

    if "$DRY_RUN"; then
        log_info "=== Dry run mode (no changes written). Use --apply to apply. ==="
    else
        log_info "=== Applying changes ==="
    fi

    local ernman_config_dir="${HOME_DIR}/.ernman_config"
    [[ ! -d "$ernman_config_dir" ]] && run_or_echo mkdir -p "$ernman_config_dir"

    install_managed_files "$ernman_config_dir"
    if component_enabled "copilot"; then
        link_directory "copilot" "${HOME_DIR}/.copilot"
    fi
    if component_enabled "omp"; then
        install_omp
    fi
    if component_enabled "ghostty"; then
        [[ ! -d "${HOME_DIR}/.config" ]] && run_or_echo mkdir -p "${HOME_DIR}/.config"
        link_directory "ghostty" "${HOME_DIR}/.config/ghostty"
    fi
    if component_enabled "vscode"; then
        [[ ! -d "${HOME_DIR}/.vscode/extensions" ]] && run_or_echo mkdir -p "${HOME_DIR}/.vscode/extensions"
        link_directory "vscode" "${HOME_DIR}/.vscode/extensions/ernman.ernman-cracked-purple-theme-0.0.1"
    fi
    if component_enabled "zed"; then
        [[ ! -d "${HOME_DIR}/.config/zed" ]] && run_or_echo mkdir -p "${HOME_DIR}/.config/zed"
        link_path "zed/themes" "${HOME_DIR}/.config/zed/themes"
    fi

    printf '\n'
    if "$DRY_RUN"; then
        log_info "=== Dry run complete. Re-run with --apply to make changes. ==="
    else
        log_info "=== Done. Open a new shell or run: source ~/.bashrc ==="
    fi
}

function run_or_echo() {
    if "$DRY_RUN"; then
        log_dry "$*"
    else
        "$@"
    fi
}

function component_enabled() {
    local component="$1"
    local c

    if [[ ${#ENABLED_COMPONENTS[@]} -eq 0 ]]; then
        return 0
    fi
    for c in "${ENABLED_COMPONENTS[@]}"; do
        [[ "$c" == "$component" ]] && return 0
    done
    return 1
}

function validate_components() {
    local components=("$@")
    local c valid

    for c in "${components[@]}"; do
        valid=false
        for v in "${VALID_COMPONENTS[@]}"; do
            [[ "$c" == "$v" ]] && valid=true && break
        done
        if ! "$valid"; then
            log_fatal "Invalid component '$c'. Valid components: ${VALID_COMPONENTS[*]}"
        fi
    done
}

function install_managed_files() {
    local ernman_config_dir="$1"
    local file file_basename file_parent_dir comment_char source_cmd source_line target_home_file target_dir

    for file in "${FILES[@]}"; do
        file_basename="$(basename "$file")"
        file_parent_dir="$(dirname "$file")"
        target_home_file="${HOME}/${file_basename}"

        if ! component_enabled "$file_parent_dir"; then
            log_skip "Component '$file_parent_dir' not enabled, skipping $file"
            continue
        fi

        case "$file_parent_dir" in
            bash)
                comment_char="#"
                source_cmd="source"
                source_line="$source_cmd \"\$HOME/.ernman_config/${file_basename}\""
                ;;
            vim)
                comment_char='"'
                source_cmd="source"
                source_line="$source_cmd \$HOME/.ernman_config/${file_basename}"
                ;;
            vi)
                comment_char='"'
                source_cmd="source"
                source_line="$source_cmd \$HOME/.ernman_config/${file_basename}"
                ;;
            neovim)
                comment_char='"'
                source_cmd="source"
                source_line="$source_cmd \$HOME/.ernman_config/${file_basename}"
                target_home_file="${HOME}/.config/nvim/${file_basename}"
                ;;
            tmux)
                comment_char="#"
                source_cmd="source-file"
                source_line="$source_cmd \"\$HOME/.ernman_config/${file_basename}\""
                ;;
            *)
                log_warn "Unknown file type for $file, skipping."
                continue
                ;;
        esac

        link_managed_file "$file" "${ernman_config_dir}/${file_basename}"
        target_dir="$(dirname "$target_home_file")"
        [[ "$target_dir" != "$HOME" && ! -d "$target_dir" ]] && run_or_echo mkdir -p "$target_dir"
        ensure_block \
            "$target_home_file" \
            "${comment_char} >>> ernman_config managed ${file_basename} >>>" \
            "${comment_char} <<< ernman_config managed ${file_basename} <<<" \
            "$source_line"
    done
}

function backup_if_needed() {
    local path="$1"
    local backup

    if [[ -e "$path" && ! -L "$path" ]]; then
        backup="${path}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warn "Backing up $path -> $backup"
        run_or_echo mv "$path" "$backup"
    fi
}

function link_managed_file() {
    local src_rel="$1"
    local dest="$2"
    local src="${REPO_DIR}/${src_rel}"

    if [[ ! -e "$src" ]]; then
        log_warn "Missing source file: $src"
        return
    fi

    if [[ -L "$dest" ]]; then
        local current
        current="$(readlink "$dest")"
        if [[ "$current" == "$src" ]]; then
            log_skip "Already linked: $dest -> $src"
            return
        fi
        log_warn "Replacing old symlink: $dest -> $current"
        run_or_echo rm -f "$dest"
    fi

    backup_if_needed "$dest"

    log_info "Linking $dest -> $src"
    run_or_echo ln -s "$src" "$dest"
    if ! "$DRY_RUN"; then
        log_ok "Linked: $dest"
    fi
}

function link_directory() {
    local src_rel="$1"
    local dest="$2"
    local src="${REPO_DIR}/${src_rel}"

    if [[ ! -d "$src" ]]; then
        log_warn "Missing source directory: $src"
        return
    fi

    if [[ -L "$dest" ]]; then
        local current
        current="$(readlink "$dest")"
        if [[ "$current" == "$src" ]]; then
            log_skip "Already linked: $dest -> $src"
            return
        fi
        log_warn "Replacing old symlink: $dest -> $current"
        run_or_echo rm -f "$dest"
    fi

    backup_if_needed "$dest"

    log_info "Linking $dest -> $src"
    run_or_echo ln -s "$src" "$dest"
    if ! "$DRY_RUN"; then
        log_ok "Linked: $dest"
    fi
}

function link_path() {
    local src_rel="$1"
    local dest="$2"
    local src="${REPO_DIR}/${src_rel}"

    if [[ ! -e "$src" ]]; then
        log_warn "Missing source path: $src"
        return
    fi

    if [[ -L "$dest" ]]; then
        local current
        current="$(readlink "$dest")"
        if [[ "$current" == "$src" ]]; then
            log_skip "Already linked: $dest -> $src"
            return
        fi
        log_warn "Replacing old symlink: $dest -> $current"
        run_or_echo rm -f "$dest"
    fi

    backup_if_needed "$dest"

    log_info "Linking $dest -> $src"
    run_or_echo ln -s "$src" "$dest"
    if ! "$DRY_RUN"; then
        log_ok "Linked: $dest"
    fi
}

function install_omp() {
    local omp_dir="${HOME_DIR}/.omp/agent"
    [[ ! -d "$omp_dir" ]] && run_or_echo mkdir -p "$omp_dir"

    link_path "omp/AGENTS.md" "${omp_dir}/AGENTS.md"
    link_path "omp/RULES.md" "${omp_dir}/RULES.md"
    link_path "omp/config.yml" "${omp_dir}/config.yml"
    link_path "omp/agents" "${omp_dir}/agents"
    link_path "omp/skills" "${omp_dir}/skills"
    link_path "omp/hooks" "${omp_dir}/hooks"
}

function ensure_block() {
    local target_file="$1"
    local start_marker="$2"
    local end_marker="$3"
    local line_to_add="$4"

    if [[ ! -e "$target_file" ]]; then
        log_info "Creating missing file: $target_file"
        run_or_echo touch "$target_file"
    fi

    if [[ -f "$target_file" ]] && grep -Fq "$start_marker" "$target_file"; then
        log_skip "Source block already present in $target_file"
        return
    fi

    log_info "Adding source block to $target_file"
    if "$DRY_RUN"; then
        log_dry "append block: $target_file"
        return
    fi

    printf '\n%s\n%s\n%s\n' "$start_marker" "$line_to_add" "$end_marker" >>"$target_file"
    log_ok "Updated: $target_file"
}

function _timestamp() { printf '[%s]' "$(date '+%Y-%m-%d %H:%M:%S')"; }
function log_info()   { printf '%s[INFO]  %s\n' "$(_timestamp)" "$*"; }
function log_warn()   { printf '%s[WARN]  %s\n' "$(_timestamp)" "$*" >&2; }
function log_error()  { printf '%s[ERROR] %s\n' "$(_timestamp)" "$*" >&2; }
function log_fatal()  { printf '%s[FATAL] %s\n' "$(_timestamp)" "$*" >&2; exit 1; }
function log_ok()     { printf '%s[OK]    %s\n' "$(_timestamp)" "$*"; }
function log_skip()   { printf '%s[SKIP]  %s\n' "$(_timestamp)" "$*"; }
function log_dry()    { printf '%s[DRY]   %s\n' "$(_timestamp)" "$*"; }

function usage() {
    cat <<EOF
Usage: ./${SCRIPT_NAME} [--apply] [--only <components>] [--help]

  --apply              Create/update symlinks and edit home files
  --only <components>  Install only specified components (comma-separated)
                       Valid: ${VALID_COMPONENTS[*]}
                       Can be repeated: --only bash --only vim
  --help               Show this help message

Without --apply, the script runs in dry-run mode.
Without --only, all components are installed.
EOF
}

function parse_args() {
    DRY_RUN=true
    ENABLED_COMPONENTS=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --apply)    DRY_RUN=false ;;
            --only)
                shift
                [[ $# -eq 0 ]] && log_fatal "--only requires an argument"
                local IFS=','
                local parts=($1)
                unset IFS
                ENABLED_COMPONENTS+=("${parts[@]}")
                ;;
            -h|--help)  usage; exit 0 ;;
            --)         shift; break ;;
            -*)         log_fatal "Unknown option: $1" ;;
            *)          log_fatal "Unknown argument: $1" ;;
        esac
        shift
    done
    readonly DRY_RUN

    if [[ ${#ENABLED_COMPONENTS[@]} -gt 0 ]]; then
        validate_components "${ENABLED_COMPONENTS[@]}"
    fi
}

main "$@"
