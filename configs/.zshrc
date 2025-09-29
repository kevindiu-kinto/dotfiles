# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    golang
    tmux
    docker
    docker-compose
    ssh-agent
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

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
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'

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

# Welcome message
echo "🚀 Development environment ready!"
echo "📁 Workspace: /workspace"
echo "🔗 Go workspace: ~/go/src/github.com -> /workspace"
echo "🔧 Go version: $(go version | cut -d' ' -f3)"