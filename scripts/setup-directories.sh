#!/bin/bash
# Directory setup and configuration script
# Setup development directories and persistent storage

set -e

echo "📁 Setting up directories and configurations..."

# Function to setup development directories
setup_directories() {
    echo "📁 Setting up development directories..."
    mkdir -p ~/go/{bin,src,pkg}
    mkdir -p ~/.vim/undodir
    mkdir -p ~/.config

    # Setup Go workspace symlink structure
    echo "🔗 Setting up Go workspace symlinks..."
    mkdir -p ~/go/src

    # Create symlink from workspace directly to github.com
    # This allows /workspace projects to appear as ~/go/src/github.com/project-name
    if [ ! -L ~/go/src/github.com ]; then
        ln -sf /workspace ~/go/src/github.com
        echo "✅ Created symlink: ~/go/src/github.com -> /workspace"
    fi
}

# Setup persistent directories for credentials and configuration
setup_persistent_directories() {
    echo "🔐 Setting up persistent directories for credentials..."

    # Create directories for persistent storage
    mkdir -p /home/dev/.config/gh
    mkdir -p /home/dev/.gnupg
    mkdir -p /home/dev/.ssh
    mkdir -p /home/dev/.docker
    mkdir -p /home/dev/.bash_history_data

    # Set proper permissions for SSH and GPG directories
    chmod 700 /home/dev/.ssh
    chmod 700 /home/dev/.gnupg

    # Create git credentials directory and file
    mkdir -p /home/dev/.git-credentials-dir
    touch /home/dev/.git-credentials-dir/credentials
    chmod 600 /home/dev/.git-credentials-dir/credentials

    # Create symlink for git credentials
    ln -sf /home/dev/.git-credentials-dir/credentials /home/dev/.git-credentials

    # Setup git config volume (persistent across rebuilds)
    mkdir -p /home/dev/.git-config-volume
    ln -sf /home/dev/.git-config-volume/.gitconfig /home/dev/.gitconfig

    # Setup bash history persistence
    touch /home/dev/.bash_history_data/.bash_history
    ln -sf /home/dev/.bash_history_data/.bash_history /home/dev/.bash_history

    # Ensure ownership is correct
    sudo chown -R dev:dev /home/dev/.config
    sudo chown -R dev:dev /home/dev/.gnupg
    sudo chown -R dev:dev /home/dev/.git-credentials-dir
    sudo chown -R dev:dev /home/dev/.git-config-volume
    sudo chown -R dev:dev /home/dev/.ssh
    sudo chown -R dev:dev /home/dev/.docker
    sudo chown -R dev:dev /home/dev/.bash_history_data

    echo "✅ Persistent directories setup completed"
}

# Setup Docker permissions
setup_docker_permissions() {
    echo "🐳 Setting up Docker permissions..."
    
    # Get the group ID of the Docker socket
    DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || echo "0")
    echo "Docker socket group ID: $DOCKER_SOCK_GID"
    
    # Add dev user to the socket owner group (usually root on macOS/OrbStack)
    if [ "$DOCKER_SOCK_GID" = "0" ]; then
        # Socket owned by root group, add user to root group
        sudo usermod -aG root dev
        echo "Added dev user to root group for Docker socket access"
    else
        # Create or modify docker group to match the socket's group ID
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

# Execute all setup functions
setup_directories
setup_persistent_directories
setup_docker_permissions

echo 'Directory setup completed with caching test'
