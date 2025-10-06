export ZSH="/usr/share/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Enhanced ARM64 optimizations for Apple Silicon development
export MAKEFLAGS="-j$(nproc) -march=armv8-a+crypto+crc+aes+sha2"
export CFLAGS="-march=armv8-a+crypto+crc+aes+sha2 -mtune=apple-m1 -O3 -pipe"
export CXXFLAGS="-march=armv8-a+crypto+crc+aes+sha2 -mtune=apple-m1 -O3 -pipe"
export LDFLAGS="-Wl,-O2 -Wl,--as-needed"
export RUSTFLAGS="-C target-cpu=apple-a14 -C target-feature=+neon,+crypto,+crc"

ZSH_THEME="robbyrussell"

plugins=(
    git
    golang
    tmux
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# GitHub CLI completion
if command -v gh &> /dev/null; then
    eval "$(gh completion -s zsh)"
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

export LANG=en_US.UTF-8
export EDITOR='vim'

export PATH=$PATH:/usr/local/go/bin:$GOBIN

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias gs='git status'
alias ga='git add'
alias gc='git commit -S'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'

alias ghpr='gh pr create'
alias ghpv='gh pr view'
alias ghpl='gh pr list'

alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'

mkcd() {
    mkdir -p "$@" && cd "$_";
}

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=/home/dev/.shell_history/zsh_history

mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -t 0 ]]; then 
    echo "🚀 Starting new tmux session"
    exec tmux new-session
fi

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
