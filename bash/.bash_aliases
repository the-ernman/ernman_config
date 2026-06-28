#!/usr/bin/env bash

# Search Aliases
alias aliass="alias | grep -i"

# Use vim if available otherwise fallback to vi
alias v='$(command -v vim &> /dev/null && echo "vim" || echo "vi")'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../../'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..' # Just in case ;)
alias ~='cd ~'
alias -- -='cd -'

# History
alias h='history'
alias hgrep='history | grep'

# Listing
alias l='ls -CF'
alias ll='ls -lhF'
alias la='ls -lAhF'
alias ls='ls --color=auto'

# Safety Nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Common Tools
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -pv'

# Tar
alias tarx='tar -xf'
alias tarz='tar -xzf'
alias tarj='tar -xjf'
alias tarc='tar -cvf'
alias tarcz='tar -czvf'
alias tarcj='tar -cjvf'
alias tartv='tar -tvf'

# Reload shell config
alias reload='source ~/.bashrc && echo "Shell reloaded."'
alias reloadp='source ~/.profile && echo "Profile reloaded."'
alias reloada='source ~/.bash_aliases && echo "Aliases reloaded."'

# Edit configs quickly
alias vbash='$EDITOR ~/.bashrc'
alias vprofile='$EDITOR ~/.profile'
alias valias='$EDITOR ~/.bash_aliases'
alias vvim='$EDITOR ~/.vimrc'
alias vtmux='$EDITOR ~/.tmux.conf'

# Tmux
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gcl='git clone'
alias gpl='git pull'
alias gsta='git stash'
alias gstp='git stash pop'

# Docker
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dr='docker run -it --rm'
alias dexec='docker exec -it'
alias dlogs='docker logs -f'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dclean='docker system prune -af --volumes'
alias dnet='docker network ls'

# Docker Compose
alias dc='docker compose'
alias dcp='docker compose ps'
alias dce='docker compose exec -it'
alias dcl='docker compose logs -f'
alias dcr='docker compose run --rm -it'
alias dcs='docker compose stop'
alias dcrm='docker compose rm -f'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'
alias kdel='kubectl delete'
alias klogs='kubectl logs -f'
alias kexec='kubectl exec -it'
alias kport='kubectl port-forward'
alias kapply='kubectl apply -f'
alias kdiff='kubectl diff -f'
alias kdesc='kubectl describe'
alias kget='kubectl get -o wide'

# JFrog CLI
alias jf='jfrog'
alias jfu='jfrog rt upload'
alias jfd='jfrog rt download'
alias jfs='jfrog rt search'

# Podman
alias pod='podman'
alias podps='podman ps'
alias podpa='podman ps -a'
alias podi='podman images'
alias podr='podman run -it --rm'
alias podexec='podman exec -it'
alias podlogs='podman logs -f'
alias podstop='podman stop'
alias podrm='podman rm'
alias podrmi='podman rmi'
alias podclean='podman system prune -af --volumes'
alias podnet='podman network ls'

# uv
alias uva='uv add'
alias uvs='uv sync'

# find
alias findf='find . -type f -name'
alias findd='find . -type d -name'
alias findi='find . -type f -iname'
alias findid='find . -type d -iname'
alias findx='find . -executable -type f -name'

# Ruff
alias ruff='ruff'
alias ruffc='ruff check'
alias ruffcf='ruff check'
alias rufff='ruff format'
alias rufffc='ruff format --check'

# Misc
function _lines() {
    # Count lines in a file
    if [[  "$#" -ne 1 ]];
    then
        echo "Usage: lines <file>"
        return 1
    fi
    if [[ ! -f "$1" ]];
    then
        echo "Error: File not found: $1"
        return 1
    fi
    wc -l < "$1"
}
alias lines='_lines'
function _ulines() {
    # Count unique lines in a file
    if [[  "$#" -ne 1 ]];
    then
        echo "Usage: ulines <file>"
        return 1
    fi
    if [[ ! -f "$1" ]];
    then
        echo "Error: File not found: $1"
        return 1
    fi
    sort "$1" -u | wc -l
}
alias ulines='_ulines'
