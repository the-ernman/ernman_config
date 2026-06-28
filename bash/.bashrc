#!/usr/bin/env bash

# Only run if this is an interactive shell
[[ $- != *i* ]] && return

# VI mode
set -o vi

# History
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s cmdhist
shopt -s histappend

# Shell Options
shopt -s autocd
shopt -s cdspell
shopt -s extglob
shopt -s dotglob
shopt -s globstar
shopt -s failglob
shopt -s nocaseglob
shopt -s checkwinsize
shopt -s inherit_errexit
shopt -s no_empty_cmd_completion

# Prompt
_no='\[\e[0m\]'
_r='\[\e[0;31m\]'
_R='\[\e[1;31m\]'
_G='\[\e[1;32m\]'
_g='\[\e[0;32m\]'
_y='\[\e[0;33m\]'
_Y='\[\e[1;33m\]'
_b='\[\e[0;34m\]'
_B='\[\e[1;34m\]'
_p='\[\e[0;35m\]'
_P='\[\e[1;35m\]'
_t='\[\e[0;36m\]'
_T='\[\e[1;36m\]'
PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    local last_code="$?"
    PS1=""
    [[ $last_code -ne 0 ]] && PS1="(${_R}$last_code${_no})"
    PS1+="${_P}[${_T}\u${_Y}@${_t}\h ${_B}\W${_P}]${_no}"
    [[ $last_code -ne 0 ]] && PS1+="${_R}\$${_no} " || PS1+="${_G}\$${_no} "
}
PS2="${_p}>>> ${_no}"
PS3="#?: "
PS4="${_p}+ ${_no}"

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/.local/run"

# Use vim if available otherwise fallback to vi
if command -v vim &> /dev/null;
then
    export EDITOR=vim
    export VISUAL=vim
else
    export EDITOR=vi
    export VISUAL=vi
fi
export LESS='-R --quit-if-one-screen'

[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
[[ -f "$HOME/.bash_extras" ]] && source "$HOME/.bash_extras"

if ! shopt -oq posix; then
    [[ -f "/usr/share/bash-completion/bash_completion" ]] && \
        source "/usr/share/bash-completion/bash_completion"
    [[ -f "/etc/bash_completion" ]] && \
        source "/etc/bash_completion"
fi

true
