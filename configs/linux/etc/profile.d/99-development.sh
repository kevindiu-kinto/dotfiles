# Development environment optimizations
# These settings enhance the development experience

# History settings for better shell experience
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=50000
export HISTFILESIZE=100000

# Default editors and pagers
export EDITOR=vim
export PAGER=less
export LESSHISTFILE=-

# Go optimizations for faster builds and downloads
export GOPROXY=direct
export GOSUMDB=off

# Node.js optimizations for better performance
export NODE_OPTIONS="--max-old-space-size=4096"
export NPM_CONFIG_PROGRESS=false
export NPM_CONFIG_AUDIT=false
export NPM_CONFIG_FUND=false

# Rust optimizations
export CARGO_TARGET_DIR=/tmp/cargo-target
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Docker buildkit optimizations
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

# Development tools optimization
export RIPGREP_CONFIG_PATH=/home/dev/.ripgreprc
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Timezone for consistent development
export TZ=UTC