# Development Environment Dotfiles

A comprehensive Docker-based development environment with Arch Linux, optimized for Go development and general programming tasks. Features **lightning-fast builds** with intelligent caching.\n\n## ⚡ TL;DR - Get Started in 30 Seconds\n\n```bash\ngit clone https://github.com/kevindiu-kinto/dotfiles.git\ncd dotfiles\nmake build          # First time: ~4 minutes\nmake shell          # Start coding!\n\n# Daily usage (super fast!):\nmake config-update  # ~5 seconds for config changes\nmake fast-build     # ~30 seconds for development\n```\n\n## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/kevindiu-kinto/dotfiles.git
   cd dotfiles
   ```

2. Build and start the environment:
   ```bash
   # First time (full build - ~4 minutes)
   make build
   
   # Subsequent builds (with cache - ~30 seconds)
   make fast-build
   
   # Config changes only (~5 seconds)
   make config-update

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

Inside the container, your workspace is properly linked to Go conventions:
```
/workspace                           # Your host directory
└── ~/go/src/
    └── github.com -> /workspace    # Direct symlink to workspace

# Example project structure:
/workspace/
├── kevindiu-kinto/
│   ├── my-go-app/              # Appears as ~/go/src/github.com/kevindiu-kinto/my-go-app
│   └── another-project/        # Appears as ~/go/src/github.com/kevindiu-kinto/another-project
└── other-user/
    └── their-project/          # Appears as ~/go/src/github.com/other-user/their-project
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
- **Docker** client - Container management
- **yay** - AUR helper for additional packages
- Various CLI tools (ripgrep, fd, bat, fzf, etc.)

### Key Features\n- ⚡ **Lightning Fast** - Multi-stage caching (5s config updates, 30s builds)\n- 🔧 **Easy to modify** - Well-structured configuration files\n- 📦 **Extensible** - Simple script to add your own tools\n- 🔄 **Persistent** - Volumes for Go modules, shell history, GitHub auth, GPG keys\n- 🔌 **VS Code Ready** - SSH access for Remote development\n- 🐹 **Go Optimized** - Proper Go workspace structure with symlinks\n- 🔐 **GitHub Ready** - Persistent GitHub CLI authentication and GPG signing\n- 🧹 **Self-contained** - Everything managed through a single Makefile

## 🔧 Customization

### Adding Your Own Tools

Edit `scripts/install-additional-tools.sh` to add your favorite tools:

**For official Arch packages:**
```bash
# Add to the pacman tools array
local tools=(
    "your-tool-name"
    "another-tool"
)
```

**For AUR packages:**
```bash
# Add to the AUR tools array
local aur_tools=(
    "visual-studio-code-bin"
    "google-chrome"
    "your-aur-package"
)
```

### Modifying Configurations

All configuration files are in the `configs/` directory:
- `.vimrc` - Vim settings and plugins
- `.zshrc` - Shell aliases, functions, and environment
- `.tmux.conf` - Tmux key bindings and appearance
- `.gitconfig` - Git aliases and settings

### Port Configuration

Modify `docker-compose.yml` to expose additional ports:

```yaml
ports:
  - "2222:22"    # SSH
  - "8080:8080"  # Your web app
  - "3000:3000"  # Node.js dev server
```

## ⚡ Optimized Build System

The environment uses a **multi-stage Docker build** with intelligent caching for dramatically faster builds:

### 🚀 Build Commands (fastest to slowest)
```bash
make config-update    # ~5 seconds  - config files only (.zshrc, .vimrc, etc.)
make fast-build       # ~30 seconds - recommended for most development
make update-tools     # ~2 minutes  - when you modify install-additional-tools.sh
make update-packages  # ~3 minutes  - update system packages
make rebuild          # ~4 minutes  - full rebuild (rarely needed)
```

### 🛠 Cache Management
```bash
make cache-info       # Show cache usage and build time estimates
make cache-clean      # Clean build cache to free disk space
```

### 💡 Performance Tips
- **Daily workflow**: Use `make config-update` for .zshrc, .vimrc changes (⚡ 99% faster)
- **Development builds**: Use `make fast-build` for regular work (⚡ 87% faster)
- **First build**: Takes ~4 minutes, but subsequent builds are much faster
- **Smart caching**: Multi-stage build separates base system → tools → configs
- **Cache benefits**: Second build onwards will be dramatically faster!

### 🏗 Build Architecture
```
Base System (cached) ──→ Tools Install (cached) ──→ Config Files (frequent changes)
    ~2 minutes              ~2 minutes                   ~5 seconds
```

## 🔐 GitHub Authentication & Commit Signing
```

## � GitHub Authentication & Commit Signing

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

## �🔌 VS Code Integration

1. Install the "Remote - SSH" extension in VS Code
2. Add this to your SSH config (`~/.ssh/config`):
   ```
   Host dev-environment
     HostName localhost
     Port 2222
     User dev
   ```
3. Connect via Command Palette: "Remote-SSH: Connect to Host" → "dev-environment"

## 📝 Complete Command Reference\n\n### 🏗️ Build Commands\n```bash\n# Basic Commands\nmake build           # Build and start (first time)\nmake start           # Start containers\nmake stop            # Stop containers\nmake restart         # Restart containers\nmake down            # Stop and remove containers\n\n# Optimized Build Commands (⚡ FAST)\nmake fast-build      # ~30s - Build with cache (recommended)\nmake config-update   # ~5s  - Update configs only (fastest)\nmake update-tools    # ~2m  - When you modify install-additional-tools.sh\nmake update-packages # ~3m  - Update system packages\nmake rebuild         # ~4m  - Full rebuild without cache (slow)\n\n# Cache Management\nmake cache-info      # Show cache usage and build time estimates\nmake cache-clean     # Clean build cache to free disk space\n\n# Access Commands\nmake shell          # Open shell in container\nmake ssh            # Connect via SSH (for VS Code)\nmake logs           # Show container logs\nmake status         # Show container status\nmake help           # Show all available commands\n```"}

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
- `gl` - git pull

### Yay (AUR) Commands
- `y` - yay (shortcut)
- `ys package` - Install package from AUR
- `yss term` - Search AUR packages
- `yu` - Update system and AUR packages
- `yr package` - Remove package
- `yc` - Clean unneeded dependencies

## 🔄 Daily Workflow\n\n### Recommended Development Flow\n```bash\n# First time setup\nmake build              # ~4 minutes (one-time)\n\n# Daily development\nmake config-update      # ~5 seconds (when changing configs)\nmake fast-build         # ~30 seconds (for code changes)\n\n# Weekly maintenance\nmake update-packages    # ~3 minutes (latest system packages)\nmake cache-clean        # Free up disk space\n```\n\n### 🎯 When to Use Each Command\n- **config-update**: Changed .zshrc, .vimrc, .gitconfig, .tmux.conf\n- **fast-build**: Added packages, modified scripts, general development\n- **update-tools**: Modified install-additional-tools.sh\n- **update-packages**: Want latest Arch Linux packages\n- **rebuild**: Something is broken, need fresh start (rarely needed)\n\n## 🏆 Performance Comparison\n\n| Operation | Before Optimization | After Optimization | Improvement |\n|-----------|--------------------|--------------------|-------------|\n| Config changes | ~4 minutes | ~5 seconds | **99% faster** |\n| Regular builds | ~4 minutes | ~30 seconds | **87% faster** |\n| Tool updates | ~4 minutes | ~2 minutes | **50% faster** |\n| Cache management | Manual | `make cache-info` | **Built-in** |"

Run `make help` to see all available commands:

**Basic:**
- `make build` - Build and start environment
- `make start/stop` - Start/stop containers
- `make restart` - Restart containers

**Maintenance:**
- `make update` - Update all packages  
- `make rebuild` - Force rebuild without cache
- `make clean` - Clean up everything

**Access:**
- `make shell` - Open container shell
- `make ssh` - Connect via SSH (for VS Code)
- `make logs` - Show container logs

## 🐛 Troubleshooting

### Can't connect via SSH
- Check if the container is running: `docker ps`
- Verify port mapping: `docker port dev-environment`
- Check SSH service: `docker exec dev-environment sudo systemctl status sshd`

### Go modules not persisting
- The `go-mod-cache` volume should persist modules between container restarts
- Check volume: `docker volume ls | grep go-mod-cache`

### Configuration changes not applied
- Configuration files are mounted as read-only from the host
- Edit files in the `configs/` directory and restart the container

## 📄 License

MIT License - feel free to use and modify as needed!

---

## 🔧 Troubleshooting\n\n### Common Issues\n\n**Build taking too long?**\n```bash\nmake cache-info    # Check cache usage\nmake cache-clean   # Free up space if needed\n```\n\n**Container won't start?**\n```bash\nmake down          # Stop everything\nmake cache-clean   # Clean cache\nmake build         # Fresh build\n```\n\n**SSH connection refused?**\n```bash\n# Remove old host key\nssh-keygen -R \"[localhost]:2222\"\n# Then try connecting again\nmake ssh\n```\n\n**Want to start completely fresh?**\n```bash\nmake down\nmake cache-clean\ndocker system prune -f  # Remove everything\nmake build              # Fresh start\n```\n\n### Getting Help\n\n- Run `make help` to see all available commands\n- Run `make cache-info` to see build time estimates\n- Check logs with `make logs`\n- View container status with `make status`\n\n---\n\n**Happy coding! 🚀**\n\n*Enjoy your blazingly fast, persistent, and fully-featured development environment!*