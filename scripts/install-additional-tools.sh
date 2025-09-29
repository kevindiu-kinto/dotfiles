#!/bin/bash
# Additional tools installation script
# This script is designed to be easily modified to add your own tools

set -e

echo "🔧 Installing additional development tools..."

# Function to install tools via pacman
install_pacman_tools() {
    local tools=(
        # Add your favorite CLI tools here
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
        # Add more tools as needed
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "📦 Installing $tool..."
            sudo pacman -S --noconfirm "$tool" || echo "❌ Failed to install $tool"
        else
            echo "✅ $tool is already installed"
        fi
    done
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
        # Add your Go development tools here
        "golang.org/x/tools/gopls@latest"                    # Go language server
        "github.com/go-delve/delve/cmd/dlv@latest"          # Go debugger
        "honnef.co/go/tools/cmd/staticcheck@latest"         # Go static analyzer
        "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" # Go linter
        # Add more Go tools as needed
    )
    
    echo "🐹 Installing Go development tools..."
    for tool in "${go_tools[@]}"; do
        echo "📦 Installing $(basename ${tool%@*})..."
        go install "$tool" || echo "❌ Failed to install $tool"
    done
}

# Function to install additional zsh plugins
install_zsh_plugins() {
    echo "🐚 Installing additional zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
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
}

# Main execution
main() {
    echo "🚀 Starting additional tools installation..."
    
    # Update package databases for fresh packages
    echo "🔄 Updating package databases..."
    sudo pacman -Sy --noconfirm
    
    # Core installations
    install_pacman_tools
    install_aur_tools
    install_go_tools
    install_zsh_plugins
    setup_directories
    
    # Optional installations (uncomment as needed)
    # install_nodejs_tools
    # install_python_tools
    
    # Final system update to ensure everything is latest
    echo "🔄 Final system update..."
    sudo pacman -Syu --noconfirm
    
    # Clean package cache to reduce image size
    echo "🧹 Cleaning package cache..."
    sudo pacman -Scc --noconfirm || true
    yay -Yc --noconfirm || true
    
    echo "✅ Additional tools installation completed!"
    echo "📝 Note: You may need to restart your shell or run 'source ~/.zshrc' to use new tools"
}

# Run the script
main "$@"