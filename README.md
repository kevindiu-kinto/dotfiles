# Development Environment Dotfiles

A comprehensive Docker-based development environment with Arch Linux, optimized for Go development and general programming tasks. Managed with a convenient Makefile.

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/kevindiu-kinto/dotfiles.git
   cd dotfiles
   ```

2. Build and start the environment:
   ```bash
   # Quick build with Makefile
   make build

   # Or see all available commands
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
├── Dockerfile              # Main container definition
├── docker-compose.yml      # Container orchestration
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

### Key Features
- 🔧 **Easy to modify** - Well-structured configuration files
- 📦 **Extensible** - Simple script to add your own tools
- 🔄 **Persistent** - Data volumes for Go modules and shell history
- 🔌 **VS Code Ready** - SSH access for Remote development
- 🐹 **Go Optimized** - Go development tools and configurations

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

## 📝 Usage Tips

### Quick Commands
```bash
make help       # Show all commands
make build      # Build and start
make shell      # Open container shell
make update     # Update packages
make ssh        # Connect via SSH
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
- `gl` - git pull

### Yay (AUR) Commands
- `y` - yay (shortcut)
- `ys package` - Install package from AUR
- `yss term` - Search AUR packages
- `yu` - Update system and AUR packages
- `yr package` - Remove package
- `yc` - Clean unneeded dependencies

## 🔄 Updates

To update the environment:

```bash
# Quick update with latest packages
make update

# Force complete rebuild (no cache)
make rebuild

# Clean everything and rebuild fresh
make fresh
```

### Available Commands

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

**Happy coding! 🚀**