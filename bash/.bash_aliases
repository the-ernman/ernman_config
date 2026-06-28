#!/usr/bin/env bash

# Search Aliases
alias aliass="alias | grep -i"

# Editor shortcut (resolves to $EDITOR configured in .bashrc)
alias v='${EDITOR:-vi}'

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
if ls --version &> /dev/null;
then
    alias ls='ls --color=auto --group-directories-first'
elif command -v gls &> /dev/null;
then
    alias ls='gls --color=auto --group-directories-first'
else
    alias ls='ls -G'
fi

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
alias g='git'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gss='git status -sb'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gds='git diff --staged'
alias glg='git log --graph --oneline --decorate --all'
alias gpf='git push --force-with-lease'
alias gup='git pull --rebase'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias gcp='git cherry-pick'
alias gsw='git switch'
alias gswc='git switch -c'
alias grs='git restore'
alias grss='git restore --staged'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gwt='git worktree'
alias gundo='git reset --soft HEAD~1'
alias gwip='git add -A && git commit -m wip'

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

# uv (Python project + tool manager)
alias uvr='uv run'
alias uva='uv add'
alias uvad='uv add --dev'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvl='uv lock'
alias uvup='uv lock --upgrade'
alias uvt='uv tool'
alias uvti='uv tool install'
alias uvtl='uv tool list'
alias uvtree='uv tree'
alias uvpy='uv python'
alias uvpip='uv pip'
alias uvve='uv venv'
alias uvexp='uv export'
alias uvi='uv init'
alias uvb='uv build'
alias uvpub='uv publish'
alias uvrp='uv run pytest'
alias uvrf='uv run ruff'
alias uvrt='uv run ty check'

# find
alias findf='find . -type f -name'
alias findd='find . -type d -name'
alias findi='find . -type f -iname'
alias findid='find . -type d -iname'
alias findx='find . -executable -type f -name'

# Ruff
alias ruffc='ruff check'
alias ruffcf='ruff check --fix'
alias rufff='ruff format'
alias rufffc='ruff format --check'

# Cargo (Rust)
alias cg='cargo'
alias cb='cargo build'
alias cbr='cargo build --release'
alias cr='cargo run'
alias crr='cargo run --release'
alias ct='cargo test'
alias cch='cargo check'
alias ccl='cargo clippy'
alias cclf='cargo clippy --fix'
alias cfm='cargo fmt'
alias cfmc='cargo fmt --check'
alias cadd='cargo add'
alias crm='cargo remove'
alias cup='cargo update'
alias cbench='cargo bench'
alias cdoc='cargo doc --open'
alias cwatch='cargo watch -x check'
alias cnext='cargo nextest run'
alias cinstall='cargo install'

# Go
alias gob='go build'
alias gor='go run'
alias got='go test'
alias gotv='go test -v'
alias gota='go test ./...'
alias gom='go mod'
alias gomt='go mod tidy'
alias gomd='go mod download'
alias gof='go fmt ./...'
alias gov='go vet ./...'
alias goi='go install'
alias gog='go get'
alias gou='go get -u'
alias gow='go work'
alias gogen='go generate ./...'
alias gocl='go clean'

# Node / npm
alias n='npm'
alias ni='npm install'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nun='npm uninstall'
alias nci='npm ci'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrs='npm run start'
alias nrl='npm run lint'
alias nst='npm start'
alias nt='npm test'
alias nout='npm outdated'
alias nup='npm update'
alias nls='npm list'
alias nx='npx'
alias npub='npm publish'

# Python
alias py='python3'
alias py3='python3'
alias pyv='python3 --version'
alias pym='python3 -m'
alias venv='python3 -m venv'
alias va='source .venv/bin/activate'
alias da='deactivate'
alias pyjson='python3 -m json.tool'
alias pyclean="find . -type d -name '__pycache__' -prune -exec rm -rf {} +"
alias ipy='ipython'

# Type checking (ty)
alias tyc='ty check'
alias tyw='ty check --watch'

# pytest
alias pt='pytest'
alias ptv='pytest -v'
alias ptx='pytest -x'
alias pts='pytest -s'
alias ptk='pytest -k'
alias ptm='pytest -m'
alias ptq='pytest -q'
alias ptlf='pytest --lf'
alias ptff='pytest --ff'
alias ptcov='pytest --cov'
alias ptpdb='pytest --pdb'
alias ptn='pytest -n auto'

# Jujutsu (jj)
alias js='jj status'
alias jn='jj new'
alias jc='jj commit'
alias jcm='jj commit -m'
alias jd='jj diff'
alias jl='jj log'
alias jla='jj log -r "all()"'
alias jde='jj describe'
alias jdm='jj describe -m'
alias je='jj edit'
alias jr='jj rebase'
alias jsq='jj squash'
alias jsp='jj split'
alias jab='jj abandon'
alias jb='jj bookmark'
alias jbs='jj bookmark set'
alias jgp='jj git push'
alias jgf='jj git fetch'
alias jgc='jj git clone'
alias jun='jj undo'
alias jop='jj op log'
alias jres='jj resolve'
alias jne='jj next --edit'
alias jpe='jj prev --edit'

# GitHub CLI
alias ghpr='gh pr create'
alias ghprv='gh pr view'
alias ghprl='gh pr list'
alias ghprc='gh pr checkout'
alias ghprm='gh pr merge'
alias ghil='gh issue list'
alias ghic='gh issue create'
alias ghiv='gh issue view'
alias ghrl='gh run list'
alias ghrw='gh run watch'
alias ghrepo='gh repo view --web'
alias ghclone='gh repo clone'

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt -recursive'
alias tfo='terraform output'
alias tfw='terraform workspace'
alias tfs='terraform state'
alias tfr='terraform refresh'

# Ansible
alias ap='ansible-playbook'
alias apc='ansible-playbook --check'
alias apv='ansible-playbook --verbose'
alias av='ansible-vault'
alias ag='ansible-galaxy'
alias agi='ansible-galaxy install'
alias ai='ansible-inventory'
alias aping='ansible all -m ping'

# Make
alias m='make'
alias mb='make build'
alias mc='make clean'
alias mt='make test'
alias mi='make install'
alias mr='make run'
alias ml='make lint'
alias mf='make fmt'

# Homebrew
alias bi='brew install'
alias binfo='brew info'
alias bu='brew update'
alias bug='brew upgrade'
alias bout='brew outdated'
alias bs='brew search'
alias brm='brew uninstall'
alias bl='brew list'
alias bcl='brew cleanup'
alias bdr='brew doctor'
alias bsv='brew services'

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

# Productivity functions
function mkcd() {
    [[ -z "$1" ]] && { echo "Usage: mkcd <dir>" >&2; return 1; }
    mkdir -p -- "$1" && cd -- "$1"
}
function extract() {
    [[ -f "$1" ]] || { echo "Usage: extract <archive>" >&2; return 1; }
    case "$1" in
        *.tar.bz2|*.tbz2) tar -xjf "$1" ;;
        *.tar.gz|*.tgz)   tar -xzf "$1" ;;
        *.tar.xz|*.txz)   tar -xJf "$1" ;;
        *.tar.zst)        tar --use-compress-program=unzstd -xf "$1" ;;
        *.tar)            tar -xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.xz)             unxz "$1" ;;
        *.zst)            unzstd "$1" ;;
        *.zip)            unzip "$1" ;;
        *.rar)            unrar x "$1" ;;
        *.7z)             7z x "$1" ;;
        *.Z)              uncompress "$1" ;;
        *)                echo "extract: unsupported format: $1" >&2; return 1 ;;
    esac
}
function serve() {
    python3 -m http.server "${1:-8000}"
}
function bak() {
    [[ -f "$1" ]] || { echo "Usage: bak <file>" >&2; return 1; }
    cp -- "$1" "$1.$(date +%Y%m%d_%H%M%S).bak"
}
