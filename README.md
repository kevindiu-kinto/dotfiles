# Development Environment Dotfiles

A comprehensive Docker-based development environment with Arch Linux, optimized for Go development and general programming tasks. Features **lightning-fast builds** with intelligent caching.

## ⚡ TL;DR - Get Started in 30 Seconds

```bash
git clone https://github.com/kevindiu-kinto/dotfiles.git
cd dotfiles
make build
make shell          # Start coding!

# Maintenance:
make clean          # Clean cache
```

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/kevindiu-kinto/dotfiles.git
   cd dotfiles
   ```

2. Build and start the environment:
   ```bash
   # Build
   make build

   # See all available commands
   make help
   ```

3. Connect to your environment:
   ```bash
   # Open shell directly
   make shell

   # Or connect via SSH (for VS Code Remote)
   make ssh
   # Password: dev
   ```

## 📁 Structure

```
dotfiles/
├── Dockerfile              # Multi-stage container with intelligent caching
├── docker-compose.yml      # Container orchestration with persistent volumes
├── Makefile                # Optimized build commands & cache management
├── configs/                # Configuration files
│   ├── .vimrc              # Vim configuration
│   ├── .zshrc              # Zsh configuration
│   ├── .tmux.conf          # Tmux configuration
│   └── .gitconfig          # Git configuration
├── scripts/                # Setup scripts
│   └── install-additional-tools.sh  # Additional tools installer
├── workspace/              # Your source code goes here
└── README.md              # This file
```

### Go Workspace Structure

The container automatically sets up a proper Go workspace:

```
/workspace (mounted from host)
    └── your-project/       # Your code here

~/go/src/github.com -> /workspace (symlinked)
    └── your-project/       # Appears as ~/go/src/github.com/your-project
```

## 🛠 What's Included

### Base System
- **Arch Linux** - Rolling release, latest packages
- **Zsh** with Oh My Zsh - Enhanced shell experience
- **Tmux** - Terminal multiplexer
- **Vim** with Go plugins - Text editor with Go support
- **SSH** - For VS Code Remote development

### Development Tools
- **Go** (latest stable) - Go programming language
- **Git** - Version control
- **GitHub CLI** - GitHub command line interface
- **GPG** - For commit signing
- **Docker** client - Container management
- **yay** - AUR helper for additional packages
- Various CLI tools (ripgrep, fd, bat, fzf, etc.)

### Key Features
- ⚡ **Lightning Fast** - Multi-stage caching (5s config updates, 30s builds)
- 🔧 **Easy to modify** - Well-structured configuration files
- 📦 **Extensible** - Simple script to add your own tools
- 🔄 **Persistent** - Volumes for Go modules, shell history, GitHub auth, GPG keys
- 🔌 **VS Code Ready** - SSH access for Remote development
- 🐹 **Go Optimized** - Proper Go workspace structure with symlinks
- 🔐 **GitHub Ready** - Persistent GitHub CLI authentication and GPG signing
- 🧹 **Self-contained** - Everything managed through a single Makefile

## ⚡ Optimized Build System

The environment uses a **multi-stage Docker build** with intelligent caching for dramatically faster builds:

### 🚀 Build Commands
```bash
make build            # Build and start (uses cache automatically after first build)
make rebuild          # Full rebuild without cache (when something is broken)
```



## 🔐 GitHub Authentication & Commit Signing

This environment provides persistent storage for GitHub credentials and GPG keys, so you only need to set them up once.

### GitHub CLI Authentication

1. Enter the container:
   ```bash
   make shell
   ```

2. Login to GitHub:
   ```bash
   gh auth login
   ```
   Follow the interactive prompts to authenticate with GitHub.

### Setting up Commit Signing

1. Generate a GPG key (inside the container):
   ```bash
   gpg --full-generate-key
   # Choose RSA and RSA, 4096 bits, no expiration
   # Use your GitHub email address
   ```

2. Get your GPG key ID:
   ```bash
   gpg --list-secret-keys --keyid-format=long
   # Look for sec   rsa4096/XXXXXXXXXXXXXXXX <- this is your key ID
   ```

3. Export your public key:
   ```bash
   gpg --armor --export YOUR_KEY_ID
   ```

4. Add the public key to GitHub:
   - Go to GitHub Settings → SSH and GPG keys
   - Click "New GPG key" and paste the public key

5. Configure Git to use your signing key:
   ```bash
   git config --global user.signingkey YOUR_KEY_ID
   git config --global commit.gpgsign true
   git config --global tag.gpgsign true
   ```

### Persistent Storage

Your credentials are automatically persisted in Docker volumes:
- `gh-config` - GitHub CLI authentication
- `git-credentials` - Git credential storage
- `gnupg-config` - GPG keys and configuration

After container rebuilds, your authentication and signing keys will be retained!

### Useful Aliases

The environment includes helpful aliases:
- `gcs` - Git commit with signature (`git commit -S`)
- `ghpr` - Create GitHub pull request (`gh pr create`)
- `ghpv` - View GitHub pull request (`gh pr view`)
- `ghpl` - List GitHub pull requests (`gh pr list`)

## 🔌 VS Code Integration

1. Install the "Remote - SSH" extension in VS Code
2. Add this to your SSH config (`~/.ssh/config`):
   ```
   Host dev-environment
     HostName localhost
     Port 2222
     User dev
   ```
3. Connect via Command Palette: "Remote-SSH: Connect to Host" → "dev-environment"

## 📝 Complete Command Reference

### 🏗️ Commands
```bash
# Essential Commands
make build           # Build and start (uses cache automatically)
make start           # Start existing containers
make stop            # Stop containers
make clean           # Clean cache (safe - preserves your data)
make rm              # Remove everything including volumes (destructive!)
make rebuild         # Full rebuild without cache (when broken)

# Access Commands
make shell           # Open shell in container
make ssh             # Connect via SSH (for VS Code)
make logs            # Show container logs
make status          # Show container status
make help            # Show all available commands
```



# Access Commands
make shell          # Open shell in container
make ssh            # Connect via SSH (for VS Code)
make logs           # Show container logs
make status         # Show container status
make help           # Show all available commands
```

### Tmux Commands
- `Ctrl+a` - Prefix key
- `Ctrl+a |` - Split vertically
- `Ctrl+a -` - Split horizontally
- `Ctrl+a h/j/k/l` - Navigate panes

### Vim Go Commands
- `,r` - Run current Go file
- `,b` - Build Go project
- `,t` - Run Go tests
- `Ctrl+n` - Toggle NERDTree

### Git Aliases
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git log --oneline

### Yay (AUR) Commands
- `yay -S package` - Install package from AUR
- `yay -Ss term` - Search AUR packages
- `yay -Syu` - Update system and AUR packages

## 🔄 Daily Workflow

### Recommended Development Flow
```bash
# First time setup
make build              # ~4 minutes (one-time)

# Daily development
make build              # ~30 seconds (uses cache automatically)

# When things break
make rebuild            # ~4 minutes (fresh start)
```

### 🎯 When to Use Each Command
- **build**: Daily development - builds and starts everything efficiently
- **clean**: Free up disk space - removes cache but keeps your valuable data
- **rm**: Nuclear option - removes EVERYTHING including Git credentials, GPG keys (be careful!)
- **rebuild**: Something is broken, need fresh start (rarely needed)
- **start/stop**: Control running containers without rebuilding

## 🏆 Performance Comparison

| Operation | Before Optimization | After Optimization | Improvement |
|-----------|--------------------|--------------------|-------------|
| Regular builds | ~4 minutes | ~30 seconds | **87% faster** |
| Cache management | Manual | Automatic | **Built-in** |

## 🔧 Troubleshooting

### Common Issues

**Build taking too long?**
```bash
make clean         # Clean cache (safe - keeps your data)
```

**Container won't start?**
```bash
make stop          # Stop everything
make clean         # Clean cache
make build         # Fresh build
```

**SSH connection refused?**
```bash
# Remove old host key
ssh-keygen -R "[localhost]:2222"
# Then try connecting again
make ssh
```

**Want to start completely fresh? (⚠️ DESTRUCTIVE)**
```bash
make rm            # This will ask for confirmation first
make build         # Fresh start
```

**Container won't start?**
```bash
make down          # Stop everything
make cache-clean   # Clean cache
make build         # Fresh build
```

**SSH connection refused?**
```bash
# Remove old host key
ssh-keygen -R "[localhost]:2222"
# Then try connecting again
make ssh
```

**Want to start completely fresh?**
```bash
make clean         # Clean everything automatically
make build         # Fresh start
```

### Getting Help

- Run `make help` to see all available commands
- Check logs with `make logs`
- View container status with `make status`

---

**Happy coding! 🚀**

*Enjoy your blazingly fast, persistent, and fully-featured development environment!*
