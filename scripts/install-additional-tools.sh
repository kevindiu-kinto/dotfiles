#!/bin/bash
# Additional tools installation script
# This script is designed to be easily modified to add your own tools

set -e

echo "🔧 Installing additional development tools..."

# Environment variables for controlling installation speed
SKIP_AUR=${SKIP_AUR:-true}     # Skip AUR by default for speed
SKIP_GO_TOOLS=${SKIP_GO_TOOLS:-false}
MINIMAL_BUILD=${MINIMAL_BUILD:-false}

# Function to install tools via pacman
install_pacman_tools() {
    local tools=(
        "ripgrep"           # Better grep
        "fd"               # Better find
        "bat"              # Better cat
        "exa"              # Better ls
        "fzf"              # Fuzzy finder
        "jq"               # JSON processor
        "yq"               # YAML processor
        "httpie"           # HTTP client
        "ncdu"             # Disk usage analyzer
        "lazygit"          # Git TUI
    )

    echo "📦 Installing all CLI tools in batch..."
    sudo pacman -S --noconfirm "${tools[@]}" || echo "❌ Some tools failed to install"
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

    # Set proper permissions for GPG directory
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

    echo "✅ Persistent directories setup completed"
}

# Main execution
main() {
    echo "🚀 Starting optimized tools installation..."

    # Single package database update
    echo "🔄 Updating package database..."
    sudo pacman -Sy --noconfirm

    # Install core tools
    install_pacman_tools

    # Skip expensive operations for faster builds
    if [ "$SKIP_GO_TOOLS" != "true" ]; then
        install_go_tools
    fi

    # Install zsh plugins (fast)
    install_zsh_plugins
    setup_directories
    setup_persistent_directories

    # Clean package cache to reduce image size
    echo "🧹 Cleaning package cache..."
    sudo pacman -Scc --noconfirm || true

    echo "✅ Optimized tools installation completed!"
}

# Run the script
main "$@"