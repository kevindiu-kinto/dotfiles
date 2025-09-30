#!/bin/bash
# Additional tools installation script
# This script is designed to be easily modified to add your own tools

set -e

echo "🔧 Installing additional development tools..."

# Function to install tools via pacman
install_pacman_tools() {
    echo "📦 Installing CLI tools in parallel categories..."
    
    # Install tools in parallel categories for faster installation
    {
        echo "🔍 Installing search and file tools..."
        sudo pacman -S --noconfirm --needed ripgrep fd bat exa fzf &
    }
    {
        echo "🔧 Installing data processing tools..."
        sudo pacman -S --noconfirm --needed jq yq httpie ncdu &
    }
    {
        echo "🐳 Installing development tools..."
        sudo pacman -S --noconfirm --needed lazygit docker docker-compose &
    }
    
    # Wait for all parallel installations to complete
    wait
    echo "✅ All CLI tools installed successfully"
}

# Function to install AUR packages via yay
install_aur_tools() {
    echo "🌟 Installing AUR packages with yay..."

    local aur_tools=(
        # Add your favorite AUR packages here
        # "visual-studio-code-bin"    # VS Code from AUR
        # "google-chrome"             # Chrome browser
        # "slack-desktop"             # Slack
        # "discord"                   # Discord
        # "postman-bin"              # API testing tool
        # "insomnia-bin"             # REST client
        # "dbeaver"                  # Database tool
        # "github-cli"               # GitHub CLI (if not in main repos)
        # Add more AUR tools as needed
    )

    for tool in "${aur_tools[@]}"; do
        if [[ ! "$tool" =~ ^#.* ]]; then  # Skip commented lines
            echo "📦 Installing $tool from AUR..."
            yay -S --noconfirm "$tool" || echo "❌ Failed to install $tool"
        fi
    done

    # Show yay usage info
    echo "💡 yay is now available! Usage examples:"
    echo "   yay -S package-name     # Install package from AUR"
    echo "   yay -Ss search-term     # Search AUR packages"
    echo "   yay -Syu               # Update system and AUR packages"
    echo "   yay -Yc                # Clean unneeded dependencies"
}

# Function to install Go tools
install_go_tools() {
    local go_tools=(
        "golang.org/x/tools/gopls@latest"                    # Go language server
        "github.com/go-delve/delve/cmd/dlv@latest"          # Go debugger
    )

    echo "🐹 Installing essential Go tools..."
    for tool in "${go_tools[@]}"; do
        go install "$tool" &
    done
    wait  # Install in parallel
}

# Function to install additional zsh plugins
install_zsh_plugins() {
    echo "🐚 Installing zsh plugins in parallel..."

    # Install plugins in parallel
    {
        if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
            git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
    } &
    {
        if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
            git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
    } &
    wait
}

# Function to install Node.js and npm tools (optional)
install_nodejs_tools() {
    echo "📦 Installing Node.js tools (optional)..."

    # Install Node.js
    if ! command -v node &> /dev/null; then
        sudo pacman -S --noconfirm nodejs npm
    fi

    # Add your favorite npm global packages here
    local npm_tools=(
        # "yarn"
        # "typescript"
        # "@vue/cli"
        # "create-react-app"
        # Add more npm tools as needed
    )

    # Uncomment to install npm tools
    # for tool in "${npm_tools[@]}"; do
    #     echo "📦 Installing $tool..."
    #     npm install -g "$tool" || echo "❌ Failed to install $tool"
    # done
}

# Function to install Python tools (optional)
install_python_tools() {
    echo "🐍 Installing Python tools (optional)..."

    # Install Python and pip
    if ! command -v python &> /dev/null; then
        sudo pacman -S --noconfirm python python-pip
    fi

    # Add your favorite Python packages here
    local python_tools=(
        # "requests"
        # "flask"
        # "django"
        # "numpy"
        # "pandas"
        # Add more Python tools as needed
    )

    # Uncomment to install Python tools
    # for tool in "${python_tools[@]}"; do
    #     echo "📦 Installing $tool..."
    #     pip install "$tool" || echo "❌ Failed to install $tool"
    # done
}

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

    # Ensure ownership is correct
    sudo chown -R dev:dev /home/dev/.config
    sudo chown -R dev:dev /home/dev/.gnupg
    sudo chown -R dev:dev /home/dev/.git-credentials-dir
    sudo chown -R dev:dev /home/dev/.git-config-volume
    sudo chown -R dev:dev /home/dev/.ssh
    sudo chown -R dev:dev /home/dev/.docker

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

# Main execution
main() {
    echo "🚀 Starting optimized tools installation..."

    # Install core tools (skip database update - already done in base-system)
    install_pacman_tools

    # Install Go tools
    install_go_tools

    # Install zsh plugins (fast)
    install_zsh_plugins
    setup_directories
    setup_persistent_directories
    setup_docker_permissions

    # Clean package cache to reduce image size
    echo "🧹 Cleaning package cache..."
    sudo pacman -Scc --noconfirm || true

    echo "✅ Optimized tools installation completed!"
}

# Run the script
main "$@"