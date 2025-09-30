# Development Environment Dotfiles

A comprehensive Docker-based development environment with Arch Linux, optimized for Go development and general programming tasks. Features **lightning-fast builds** with intelligent caching and **automated container entry**.

## ⚡ TL;DR - Get Started in 30 Seconds

```bash
git clone https://github.com/kevindiu-kinto/dotfiles.git
cd dotfiles
make build
make install        # Auto-enter container on terminal open
# Open new terminal → Automatically in container!

# Manual entry:
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

3. **Enable auto-container entry (Recommended):**
   ```bash
   make install        # Sets up automatic container entry
   # Now opening any terminal will auto-enter the container!
   ```

4. Connect to your environment:
   ```bash
   # Open shell directly
   make shell          # Use 'exit' to return to host terminal

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
- **Zsh** with Oh My Zsh - Enhanced shell experience (default)
- **Tmux** - Terminal multiplexer (auto-starts on SSH)
- **Vim** with Go plugins - Text editor with Go support
- **SSH** - For VS Code Remote development

### Development Tools
- **Go** (latest stable) - Go programming language with integrated caching
- **Git** - Version control
- **GitHub CLI** - GitHub command line interface
- **GPG** - For commit signing
- **Docker CLI** - Container management with Docker-in-Docker support
- **Docker Compose** - Multi-container application orchestration
- **AWS CLI** - Amazon Web Services command line interface
- **Terraform** (via tfenv) - Infrastructure as code tool with version management
- **yay** - AUR helper for additional packages
- Various CLI tools (ripgrep, fd, bat, fzf, etc.)

### Key Features
- ⚡ **Lightning Fast** - Multi-stage caching (5s config updates, 30s builds)
- 🚀 **Auto-Entry** - Automatically enter container when opening terminal (`make install`)
- 🎯 **Go Cache Integration** - 444MB+ of cached Go modules and binaries for instant builds
- 🔧 **Easy to modify** - Well-structured configuration files
- 📦 **Extensible** - Simple script to add your own tools
- 🔄 **Persistent** - 10 volumes for complete data persistence (Go cache, AWS config, shell histories, etc.)
- 🔌 **VS Code Ready** - SSH access for Remote development
- 🐹 **Go Optimized** - Proper Go workspace structure with symlinks and persistent cache
- 🔐 **GitHub Ready** - Persistent GitHub CLI authentication and GPG signing
- ☁️ **Cloud Ready** - AWS CLI and Terraform pre-installed with persistent configuration
- 🐳 **Docker-in-Docker** - Full Docker support for containerized development
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

Your credentials and configurations are automatically persisted in Docker volumes:
- `go-cache` - **Integrated Go cache** for modules, binaries, and workspace (444MB+ cached)
- `zsh-history` - Zsh shell command history
- `bash-history` - Bash shell command history
- `gh-config` - GitHub CLI authentication
- `aws-config` - AWS CLI configuration and credentials
- `git-credentials` - Git credential storage
- `gnupg-config` - GPG keys and configuration
- `git-config` - Git configuration (user.name, user.email, etc.)
- `ssh-config` - SSH keys, config, and known_hosts
- `docker-config` - Docker CLI configuration and registry credentials

After container rebuilds, all your authentication, keys, configurations, and **Go development cache** will be retained!

## 🐳 Docker-in-Docker Support

The environment includes full Docker support for containerized development workflows:

### Features
- **Docker CLI** - Build, run, and manage containers
- **Docker Compose** - Orchestrate multi-container applications
- **Host Integration** - Shares Docker daemon with host for efficiency
- **Persistent Config** - Docker credentials and settings persist across rebuilds

### Usage Examples
```bash
# Inside the development environment
make shell

# Build Docker images
docker build -t myapp .

# Run containers
docker run -d --name web nginx
docker ps

# Use Docker Compose
docker-compose up -d
docker-compose logs

# Manage images
docker images
docker pull postgres:latest
```

### Common Workflows
- **Microservices Development** - Build and test multiple services
- **CI/CD Pipeline Development** - Test Docker builds locally
- **Container Orchestration** - Develop Docker Compose applications
- **Database Testing** - Spin up databases in containers for testing

### Useful Aliases

The environment includes helpful aliases:
- `gcs` - Git commit with signature (`git commit -S`)
- `ghpr` - Create GitHub pull request (`gh pr create`)
- `ghpv` - View GitHub pull request (`gh pr view`)
- `ghpl` - List GitHub pull requests (`gh pr list`)

## � **Auto-Container Entry** (New!)

Skip manual `make shell` commands! Set up automatic container entry:

```bash
make install        # One-time setup
```

**What it does:**
- Automatically detects your shell (zsh/bash)
- Adds smart auto-entry code to your shell config
- Opening any terminal automatically enters the development container
- Only activates when container is running
- Prevents duplicate installations

**Benefits:**
- **Seamless workflow** - Just open terminal and you're coding
- **Smart detection** - Works with zsh, bash, or bash_profile
- **Safe** - Won't break existing configurations
- **Easy exit** - Simply type `exit` to return to host terminal

### Manual Container Access

If you prefer manual control:
```bash
make shell          # Enter container manually (use 'exit' to return)
make ssh            # SSH access for VS Code
```

## � VS Code Integration

1. Install the "Remote - SSH" extension in VS Code
2. Add this to your SSH config (`~/.ssh/config`):
   ```
   Host dev-environment
     HostName localhost
     Port 2222
     User dev
   ```
3. Connect via Command Palette: "Remote-SSH: Connect to Host" → "dev-environment"

## �📝 Complete Command Reference

### 🏗️ Build & Setup Commands
```bash
# Essential Commands
make build           # Build and start (uses cache automatically)
make install         # Set up auto-container entry (recommended!)
make start           # Start existing containers
make stop            # Stop containers
make clean           # Clean cache (safe - preserves your data)
make rm              # Remove everything including volumes (destructive!)
make rebuild         # Full rebuild without cache (when broken)

# Access Commands
make shell           # Open tmux session with zsh in container
make ssh             # Connect via SSH (for VS Code)
make logs            # Show container logs
make status          # Show container status
make help            # Show all available commands
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
make install            # Set up auto-container entry

# Daily development (with auto-entry)
# Just open terminal → Automatically in container!

# Daily development (manual)
make build              # ~30 seconds (uses cache automatically)
make shell              # Enter development environment

# Inside the container - Go development
cd ~/go/src/github.com/your-project
go mod tidy             # Uses persistent Go cache
go run main.go          # Lightning fast with cached dependencies

# Inside the container - Cloud development
aws configure           # Persistent AWS config
terraform init          # Version managed by tfenv
terraform plan

# Inside the container - Docker development
docker build -t myapp .
docker run --rm myapp
docker-compose up -d

# When things break
make rebuild            # ~4 minutes (fresh start)
```

### 🎯 When to Use Each Command
- **build**: Daily development - builds and starts everything efficiently
- **install**: One-time setup for automatic container entry (highly recommended!)
- **clean**: Free up disk space - removes cache but keeps your valuable data
- **rm**: Nuclear option - removes EVERYTHING including Git credentials, GPG keys (be careful!)
- **rebuild**: Something is broken, need fresh start (rarely needed)
- **start/stop**: Control running containers without rebuilding

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

**Can't exit from container?**
```bash
exit               # Simply type 'exit' to return to host terminal
```

### Getting Help

- Run `make help` to see all available commands
- Check logs with `make logs`
- View container status with `make status`

---

**Happy coding! 🚀**

*Enjoy your blazingly fast, auto-entering, persistent, and fully-featured development environment!*

**Pro tip:** Run `make install` for the ultimate seamless development experience - just open a terminal and start coding! Use `exit` to return to host when needed. 🎯
