#!/bin/bash

set -euo pipefail

echo "📁 Setting up directories and configurations..."

setup_directories() {
    mkdir -p ~/.vim/undodir ~/.config

    if [ ! -L ~/go/src/github.com ]; then
        mkdir -p ~/go/src
        ln -sf /workspace ~/go/src/github.com
        echo "✅ Created symlink: ~/go/src/github.com -> /workspace"
    fi
}

setup_ssh_directories() {
    echo "🔧 Setting up SSH directories..."
    sudo mkdir -p /var/run/sshd /usr/share/empty.sshd
    sudo chmod 755 /usr/share/empty.sshd
    echo "✅ SSH directories setup completed"
}

setup_symlinks() {
    echo "� Setting up symlinks..."
    
    ln -sf /home/dev/.git_tools/git-credentials/credentials /home/dev/.git-credentials
    ln -sf /home/dev/.git_tools/git-config/.gitconfig /home/dev/.gitconfig
    ln -sf /home/dev/.shell_history/bash_history /home/dev/.bash_history
    ln -sf /home/dev/.security/ssh /home/dev/.ssh
    ln -sf /home/dev/.security/gnupg /home/dev/.gnupg
    ln -sf /home/dev/.git_tools/gh /home/dev/.config/gh

    echo "✅ Symlinks setup completed"
}

setup_docker_permissions() {
    echo "🔄 Setting up Docker permissions..."
    
    DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || echo "0")
    
    if [ "$DOCKER_SOCK_GID" = "0" ]; then
        sudo usermod -aG root dev
        echo "✅ Added dev user to root group for Docker access"
    else
        if getent group docker > /dev/null 2>&1; then
            sudo groupmod -g "$DOCKER_SOCK_GID" docker 2>/dev/null || true
        else
            sudo groupadd -g "$DOCKER_SOCK_GID" docker 2>/dev/null || true
        fi
        sudo usermod -aG docker dev
        echo "✅ Docker permissions setup completed"
    fi
}

setup_directories
setup_symlinks
setup_ssh_directories
setup_docker_permissions

echo '✅ Directory setup completed!'
