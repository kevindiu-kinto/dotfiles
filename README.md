# Development Environment Dotfiles

Docker-based development environment with Arch Linux for Go development and general programming.

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
- 🚀 **Auto-Entry** - Automatic container entry (`make install`)
- 💾 **Persistent Storage** - Configs and credentials survive rebuilds
- 🐹 **Multi-Language** - Go, Node.js support
- ☁️ **Cloud Native** - Kubernetes + AWS tools
- 🐳 **Docker-in-Docker** - Full container development

## 📋 Commands

```bash
make build           # Build and start
make install         # Set up auto-container entry
make start           # Start existing containers
make stop            # Stop containers
make clean           # Clean up
make rm              # Remove everything including volumes
make shell           # Open tmux session
make ssh             # SSH access (for VS Code Remote)
make help            # Show all commands
```

## 🔐 VS Code Integration

1. Install "Remote - SSH" extension
2. Add to `~/.ssh/config`:
   ```
   Host dev-environment
     HostName localhost
     Port 2222
     User dev
   ```
3. Connect via "Remote-SSH: Connect to Host" → "dev-environment"
4. Password: `dev`
