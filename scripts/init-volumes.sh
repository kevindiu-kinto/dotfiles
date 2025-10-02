#!/bin/bash

set -e

echo "🚀 Initializing Docker volumes..."

init_volume_structure() {
    echo "📁 Creating directory structures..."
    
    mkdir -p /mnt/shell-history
    mkdir -p /mnt/git-tools/{gh,git-credentials,git-config}
    mkdir -p /mnt/security-tools/{ssh,gnupg,ssh-host-keys}
    mkdir -p /mnt/aws-config
    mkdir -p /mnt/docker-config
    mkdir -p /mnt/npm-cache
    mkdir -p /mnt/vscode-config
    mkdir -p /mnt/go-cache/{.cache,pkg,src}
    
    echo "✅ Directory structures created"
}

init_volume_files() {
    echo "📄 Creating initial files..."
    
    mkdir -p /mnt/git-tools/git-credentials
    touch /mnt/git-tools/git-credentials/credentials
    
    touch /mnt/shell-history/bash_history
    touch /mnt/shell-history/zsh_history
    touch /mnt/shell-history/tmux_history
    
    echo "✅ Initial files created"
}

set_volume_ownership() {
    echo "👤 Setting volume ownership..."
    
    chown -R 1000:1000 /mnt/security-tools /mnt/go-cache /mnt/shell-history \
                       /mnt/git-tools /mnt/aws-config /mnt/vscode-config \
                       /mnt/npm-cache /mnt/docker-config
    
    echo "✅ Volume ownership set to dev:dev (1000:1000)"
}

set_volume_permissions() {
    echo "🔒 Setting volume permissions..."
    
    chmod -R 755 /mnt/go-cache /mnt/git-tools /mnt/aws-config \
                 /mnt/vscode-config /mnt/npm-cache /mnt/docker-config
    
    chmod 755 /mnt/shell-history
    chmod 644 /mnt/shell-history/bash_history
    chmod 644 /mnt/shell-history/zsh_history
    chmod 644 /mnt/shell-history/tmux_history
    
    chmod -R 700 /mnt/security-tools
    
    chmod 600 /mnt/git-tools/git-credentials/credentials
    
    echo "✅ Volume permissions configured"
}

init_volume_structure
init_volume_files
set_volume_ownership
set_volume_permissions

echo "🎉 Volume initialization completed successfully!"