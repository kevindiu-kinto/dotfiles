#!/bin/bash

set -e

echo "📁 Setting up directories and configurations..."

setup_directories() {
    echo "📁 Setting up development directories..."
    mkdir -p ~/go/{bin,src,pkg}
    mkdir -p ~/.vim/undodir
    mkdir -p ~/.config

    echo "🔗 Setting up Go workspace symlinks..."
    mkdir -p ~/go/src

    if [ ! -L ~/go/src/github.com ]; then
        ln -sf /workspace ~/go/src/github.com
        echo "✅ Created symlink: ~/go/src/github.com -> /workspace"
    fi
}

setup_persistent_directories() {
    echo "🔐 Setting up persistent directories for credentials..."

    mkdir -p /home/dev/.config/gh
    mkdir -p /home/dev/.gnupg
    mkdir -p /home/dev/.ssh
    mkdir -p /home/dev/.docker
    mkdir -p /home/dev/.bash_history_data
    mkdir -p /home/dev/.aws

    chmod 700 /home/dev/.ssh
    chmod 700 /home/dev/.gnupg

    mkdir -p /home/dev/.git-credentials-dir
    touch /home/dev/.git-credentials-dir/credentials
    chmod 600 /home/dev/.git-credentials-dir/credentials

    ln -sf /home/dev/.git-credentials-dir/credentials /home/dev/.git-credentials

    mkdir -p /home/dev/.git-config-volume
    ln -sf /home/dev/.git-config-volume/.gitconfig /home/dev/.gitconfig

    touch /home/dev/.bash_history_data/.bash_history
    ln -sf /home/dev/.bash_history_data/.bash_history /home/dev/.bash_history

    sudo chown -R dev:dev /home/dev/.config
    sudo chown -R dev:dev /home/dev/.gnupg
    sudo chown -R dev:dev /home/dev/.git-credentials-dir
    sudo chown -R dev:dev /home/dev/.git-config-volume
    sudo chown -R dev:dev /home/dev/.ssh
    sudo chown -R dev:dev /home/dev/.docker
    sudo chown -R dev:dev /home/dev/.bash_history_data
    sudo chown -R dev:dev /home/dev/.aws

    echo "✅ Persistent directories setup completed"
}

setup_docker_permissions() {
    echo "🐳 Setting up Docker permissions..."
    
    DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || echo "0")
    echo "Docker socket group ID: $DOCKER_SOCK_GID"
    
    if [ "$DOCKER_SOCK_GID" = "0" ]; then
        sudo usermod -aG root dev
        echo "Added dev user to root group for Docker socket access"
    else
        if getent group docker > /dev/null 2>&1; then
            sudo groupmod -g "$DOCKER_SOCK_GID" docker 2>/dev/null || true
        else
            sudo groupadd -g "$DOCKER_SOCK_GID" docker 2>/dev/null || true
        fi
        sudo usermod -aG docker dev
        echo "Added dev user to docker group (GID: $DOCKER_SOCK_GID)"
    fi
    
    echo "✅ Docker permissions setup completed"
}

setup_directories
setup_persistent_directories
setup_docker_permissions

echo 'Directory setup completed with caching test'
