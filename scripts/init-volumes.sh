#!/bin/bash

set -euo pipefail

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
    
    touch /mnt/shell-history/{bash_history,zsh_history,tmux_history}
    
    echo "✅ Initial files created"
}

set_volume_ownership() {
    echo "👤 Setting volume ownership..."
    
    # Skip chown when running as dev user - files are already owned correctly
    if [ "$(id -u)" = "0" ]; then
        chown -R 1001:1001 /mnt/{security-tools,go-cache,shell-history,git-tools,aws-config,vscode-config,npm-cache,docker-config}
        echo "✅ Volume ownership set to dev:dev (1001:1001)"
    else
        echo "✅ Running as dev user - ownership already correct"
    fi
}

setup_ssh_keys() {
    echo "🔑 Setting up SSH keys..."
    
    if [ -f /host-ssh/dev-environment.pub ]; then
        echo "📋 Installing SSH public key..."
        cp /host-ssh/dev-environment.pub /mnt/security-tools/ssh/authorized_keys
        chmod 600 /mnt/security-tools/ssh/authorized_keys
        echo "✅ SSH key installed"
    else
        echo "⚠️  No SSH public key found at /host-ssh/dev-environment.pub"
        echo "   Run 'make ssh-setup' to generate keys first"
    fi
}

set_volume_permissions() {
    echo "🔒 Setting volume permissions..."
    
    # Set permissions for directories and files we can modify
    chmod -R 755 /mnt/{go-cache,git-tools,aws-config,vscode-config,npm-cache,docker-config} 2>/dev/null || true
    
    chmod 755 /mnt/shell-history 2>/dev/null || true
    chmod 644 /mnt/shell-history/{bash_history,zsh_history,tmux_history} 2>/dev/null || true
    
    # Only set permissions on security-tools if we own the files
    if [ "$(id -u)" = "0" ]; then
        chmod -R 700 /mnt/security-tools
    else
        # Set permissions only on files we own, ignore errors for others
        find /mnt/security-tools -user $(id -u) -exec chmod 700 {} \; 2>/dev/null || true
    fi
    
    chmod 600 /mnt/git-tools/git-credentials/credentials 2>/dev/null || true
    
    echo "✅ Volume permissions configured"
}

init_volume_structure
init_volume_files
set_volume_ownership
set_volume_permissions

echo "🎉 Volume initialization completed successfully!"