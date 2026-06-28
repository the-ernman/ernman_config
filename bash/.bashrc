#!/usr/bin/env bash

# Only run if this is an interactive shell
[[ $- != *i* ]] && return

# VI mode
set -o vi

# History
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%F %T '
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
    history -a
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

# File-type colors
LS_COLORS='di=1;38;2;0;102;255:ln=38;2;148;226;213:or=48;2;243;139;168;38;2;17;17;27:mi=48;2;243;139;168;38;2;17;17;27:ex=1;38;2;166;227;161:pi=38;2;245;194;231:so=38;2;245;194;231:bd=1;38;2;249;226;175:cd=1;38;2;249;226;175:'
LS_COLORS+='*.tar=1;38;2;243;139;168:*.tgz=1;38;2;243;139;168:*.tbz=1;38;2;243;139;168:*.tbz2=1;38;2;243;139;168:*.txz=1;38;2;243;139;168:*.tzst=1;38;2;243;139;168:*.taz=1;38;2;243;139;168:*.tlz=1;38;2;243;139;168:*.zip=1;38;2;243;139;168:*.7z=1;38;2;243;139;168:*.rar=1;38;2;243;139;168:*.jar=1;38;2;243;139;168:*.war=1;38;2;243;139;168:*.ear=1;38;2;243;139;168:*.cab=1;38;2;243;139;168:*.arj=1;38;2;243;139;168:*.cpio=1;38;2;243;139;168:'
LS_COLORS+='*.gz=38;2;243;139;168:*.bz2=38;2;243;139;168:*.bz=38;2;243;139;168:*.xz=38;2;243;139;168:*.zst=38;2;243;139;168:*.lz=38;2;243;139;168:*.lz4=38;2;243;139;168:*.lzma=38;2;243;139;168:*.lzo=38;2;243;139;168:*.Z=38;2;243;139;168:*.br=38;2;243;139;168:'
LS_COLORS+='*.iso=1;38;2;203;166;247:*.img=1;38;2;203;166;247:*.squashfs=1;38;2;203;166;247:*.sfs=1;38;2;203;166;247:*.dmg=1;38;2;203;166;247:*.qcow=1;38;2;203;166;247:*.qcow2=1;38;2;203;166;247:*.vmdk=1;38;2;203;166;247:*.vdi=1;38;2;203;166;247:*.vhd=1;38;2;203;166;247:*.vhdx=1;38;2;203;166;247:*.nrg=1;38;2;203;166;247:*.mdf=1;38;2;203;166;247:'
LS_COLORS+='*.deb=1;38;2;250;179;135:*.rpm=1;38;2;250;179;135:*.apk=1;38;2;250;179;135:*.pkg=1;38;2;250;179;135:*.snap=1;38;2;250;179;135:*.AppImage=1;38;2;250;179;135:*.flatpak=1;38;2;250;179;135:*.flatpakref=1;38;2;250;179;135:*.msi=1;38;2;250;179;135:*.gem=1;38;2;250;179;135:*.whl=1;38;2;250;179;135:*.egg=1;38;2;250;179;135:*.nupkg=1;38;2;250;179;135:*.crx=1;38;2;250;179;135:*.xpi=1;38;2;250;179;135:'
LS_COLORS+='*Dockerfile=1;38;2;116;199;236:*.dockerfile=1;38;2;116;199;236:*Containerfile=1;38;2;116;199;236:*.dockerignore=38;2;116;199;236:*docker-compose.yml=1;38;2;116;199;236:*docker-compose.yaml=1;38;2;116;199;236:*compose.yml=1;38;2;116;199;236:*compose.yaml=1;38;2;116;199;236:*.tf=38;2;116;199;236:*.tfvars=38;2;116;199;236:*.tfstate=38;2;116;199;236:*Vagrantfile=1;38;2;116;199;236:'
LS_COLORS+='*.jpg=38;2;249;226;175:*.jpeg=38;2;249;226;175:*.png=38;2;249;226;175:*.gif=38;2;249;226;175:*.bmp=38;2;249;226;175:*.svg=38;2;249;226;175:*.webp=38;2;249;226;175:*.ico=38;2;249;226;175:*.tiff=38;2;249;226;175:*.heic=38;2;249;226;175:'
LS_COLORS+='*.mp4=38;2;245;194;231:*.mkv=38;2;245;194;231:*.webm=38;2;245;194;231:*.mov=38;2;245;194;231:*.avi=38;2;245;194;231:*.flv=38;2;245;194;231:*.wmv=38;2;245;194;231:*.m4v=38;2;245;194;231:'
LS_COLORS+='*.mp3=38;2;242;205;205:*.flac=38;2;242;205;205:*.wav=38;2;242;205;205:*.ogg=38;2;242;205;205:*.m4a=38;2;242;205;205:*.opus=38;2;242;205;205:*.aac=38;2;242;205;205:'
LS_COLORS+='*LICENSE=38;2;180;190;254:*.pdf=38;2;180;190;254:*.md=38;2;180;190;254:*.doc=38;2;180;190;254:*.docx=38;2;180;190;254:*.odt=38;2;180;190;254:*.epub=38;2;180;190;254:*.rtf=38;2;180;190;254:'
LS_COLORS+='*.rs=1;38;2;0;255;198:*.py=1;38;2;0;255;198:*.ts=1;38;2;0;255;198:*.tsx=1;38;2;0;255;198:*.js=1;38;2;0;255;198:*.jsx=1;38;2;0;255;198:*.mjs=1;38;2;0;255;198:*.cjs=1;38;2;0;255;198:*.cpp=1;38;2;0;255;198:*.cc=1;38;2;0;255;198:*.cxx=1;38;2;0;255;198:*.c=1;38;2;0;255;198:*.h=1;38;2;0;255;198:*.hpp=1;38;2;0;255;198:*.hh=1;38;2;0;255;198:*.hxx=1;38;2;0;255;198:*.sh=1;38;2;0;255;198:*.bash=1;38;2;0;255;198:*.zsh=1;38;2;0;255;198:*.go=1;38;2;0;255;198:*.java=1;38;2;0;255;198:*.kt=1;38;2;0;255;198:*.swift=1;38;2;0;255;198:*.rb=1;38;2;0;255;198:*.php=1;38;2;0;255;198:*.lua=1;38;2;0;255;198:*.cs=1;38;2;0;255;198:'
export LS_COLORS
export CLICOLOR=1
export LSCOLORS='ExGxFxdxCxegedabagaced'

[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
[[ -f "$HOME/.bash_extras" ]] && source "$HOME/.bash_extras"

if ! shopt -oq posix; then
    [[ -f "/usr/share/bash-completion/bash_completion" ]] && \
        source "/usr/share/bash-completion/bash_completion"
    [[ -f "/etc/bash_completion" ]] && \
        source "/etc/bash_completion"
    [[ -f "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && \
        source "/opt/homebrew/etc/profile.d/bash_completion.sh"
    [[ -f "/usr/local/etc/profile.d/bash_completion.sh" ]] && \
        source "/usr/local/etc/profile.d/bash_completion.sh"
fi

true
