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
export GOPATH=$HOME/go
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
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --decorate --graph'

# Go aliases
alias gob='go build'
alias gor='go run'
alias got='go test'
alias gom='go mod'
alias gof='go fmt'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'

# Tmux aliases
alias tm='tmux'
alias tma='tmux attach'
alias tmn='tmux new-session'
alias tms='tmux list-sessions'

# Yay aliases (AUR helper)
alias y='yay'
alias ys='yay -S'          # Install package
alias yss='yay -Ss'        # Search packages
alias yu='yay -Syu'        # Update system and AUR
alias yr='yay -R'          # Remove package
alias yc='yay -Yc'         # Clean dependencies
alias yq='yay -Q'          # List installed packages
alias yqi='yay -Qi'        # Package info

# Custom functions
mkcd() {
    mkdir -p "$@" && cd "$_";
}

# Find and kill process by name
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    lsof -ti:$1 | xargs kill -9
}

# Show yay usage examples
yay-help() {
    echo "🌟 Quick yay Commands:"
    echo "  ys package    # Install package"
    echo "  yss search    # Search packages" 
    echo "  yu           # Update all packages"
    echo "  yr package   # Remove package"
    echo "  yc           # Clean dependencies"
    echo "  yq           # List installed packages"
    echo ""
    echo "Run '/workspace/yay-examples.sh' for more examples!"
}

# Git branch in prompt (if not using oh-my-zsh theme that includes it)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Auto-completion
autoload -U compinit
compinit

# Key bindings
bindkey '^R' history-incremental-search-backward

# Welcome message
echo "🚀 Development environment ready!"
echo "📁 Workspace: /workspace"
echo "🔧 Go version: $(go version | cut -d' ' -f3)"
echo "📝 Vim plugins: Run ':PlugInstall' in vim to install plugins"