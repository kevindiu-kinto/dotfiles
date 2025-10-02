# Development Environment Dotfiles

A complete, ready-to-use development environment that runs in Docker. Perfect for Go development, cloud-native projects, and general programming. No more "it works on my machine" - get a consistent development environment anywhere.

## 🚀 Quick Start

```bash
git clone https://github.com/kevindiu-kinto/dotfiles.git
cd dotfiles
make build
make shell
```

## 🛠 What's Included

### Development Tools
- **Go** (latest) + tools (gopls, dlv)
- **Node.js** + npm 
- **Kubernetes** - kubectl, helm, k9s
- **Cloud** - AWS CLI with SSO support
- **Terraform** (via tfenv)
- **Git** + GitHub CLI + GPG
- **Docker** + Compose with Docker-in-Docker
- **CLI Tools** - ripgrep, fd, bat, fzf, jq, yq, httpie, lazygit, zip

### Base System
- **Arch Linux** with latest packages
- **Zsh** with Oh My Zsh (default shell)
- **Tmux** for terminal multiplexing
- **Vim** with Go plugins
- **SSH** server for VS Code Remote

### Key Features
- 🚀 **One Command Setup** - \`make build\` and you're ready to code
- 💾 **Persistent Data** - Your work, configs, and credentials are saved across restarts
- 🔑 **VS Code Ready** - Seamless integration with VS Code Remote-SSH
- 🐹 **Go Development** - Optimized for Go with gopls, delve debugger, and proper module support
- ☁️ **Cloud Development** - AWS CLI, kubectl, helm, and Terraform pre-configured
- 🐳 **Container Native** - Docker-in-Docker for building and testing containers
- ⚡ **Fast Startup** - Pre-built environment launches in seconds

## 📋 Commands

### Getting Started
```bash
make build           # Initial setup - builds and starts everything
make shell           # Enter your development environment
```

### Daily Usage
```bash
make start           # Start the environment (after stopping)
make stop            # Stop the environment (keeps your data)
make install         # Auto-enter container when opening terminal
```

### VS Code Integration
```bash
make ssh-setup       # Set up VS Code Remote-SSH (one-time setup)
make ssh             # Manual SSH connection
```

### Maintenance
```bash
make clean           # Clean up Docker cache and temporary files
make rm              # Remove everything (⚠️ deletes all your work)
make help            # Show all available commands
```

## 🔐 VS Code Integration

### Option 1: Automatic Setup (Recommended)
```bash
make ssh-setup       # Handles everything automatically
```
Then in VS Code: \`Remote-SSH: Connect to Host\` → \`dev-environment\`

### Option 2: Manual Setup
1. Install "Remote - SSH" extension in VS Code
2. Add to \`~/.ssh/config\`:
   ```
   Host dev-environment
     HostName localhost
     Port 2222
     User dev
   ```
3. Connect via "Remote-SSH: Connect to Host" → "dev-environment"
4. Password: \`dev\`

The automatic setup creates SSH keys for passwordless access and handles all configuration.

## 💡 Tips

- **First time**: Run \`make build\` to set everything up
- **Daily use**: Just \`make shell\` to start coding
- **VS Code users**: Use \`make ssh-setup\` once, then connect via Remote-SSH
- **Auto-entry**: Run \`make install\` to automatically enter the container when you open a terminal
- **Persistent data**: Your code, Git config, AWS credentials, and shell history are saved between sessions

## 🗂 What Gets Persisted

Your development environment saves:
- All your code and projects in \`/workspace\`
- Git configuration and credentials
- SSH keys and GPG keys
- AWS credentials and config
- Shell history (zsh, bash, tmux)
- Go module cache and compiled binaries
- npm cache and global packages
- VS Code extensions and settings

## 🔧 Customization

- **Shell config**: Edit \`configs/.zshrc\`
- **Vim config**: Edit \`configs/.vimrc\`
- **Tmux config**: Edit \`configs/.tmux.conf\`
- **Add tools**: Modify \`scripts/install-*-tools.sh\`

## 🐛 Troubleshooting

**Container won't start?**
```bash
make clean && make build
```

**VS Code connection issues?**
```bash
make ssh-setup  # Resets SSH configuration
```

**Want to start fresh?**
```bash
make rm         # ⚠️ This deletes everything
make build      # Rebuild from scratch
```
