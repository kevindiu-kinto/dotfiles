# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# GPG TTY configuration for commit signing
export GPG_TTY=$(tty)

# Oh My Zsh configuration
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    golang
    tmux
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh first
source $ZSH/oh-my-zsh.sh

# GitHub CLI completion (after Oh My Zsh is loaded)
if command -v gh &> /dev/null; then
    eval "$(gh completion -s zsh)"
fi

# SSH Agent configuration (container-friendly)
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

# User configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Go configuration
export GOPATH=$(go env GOPATH)  # Use Go's default GOPATH
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcs='git commit -S'  # Signed commit
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'

# GitHub CLI aliases
alias ghpr='gh pr create'
alias ghpv='gh pr view'
alias ghpl='gh pr list'

# Docker aliases
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'

# Custom functions
mkcd() {
    mkdir -p "$@" && cd "$_";
}

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=/home/dev/.shell_history/zsh_history

# Create history directory if it doesn't exist
mkdir -p "$(dirname "$HISTFILE")"

# History options
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
