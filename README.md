# Development Environment Dotfiles

A comprehensive Docker-based development environment with Arch Linux, optimized for Go development and general programming tasks.

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/kevindiu-kinto/dotfiles.git
   cd dotfiles
   ```

2. Build and start the environment:
   ```bash
   docker-compose up -d
   ```

3. Connect via SSH (for VS Code Remote):
   ```bash
   ssh dev@localhost -p 2222
   # Password: dev
   ```

4. Or attach directly to the container:
   ```bash
   docker exec -it dev-environment zsh
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
# Rebuild the container
docker-compose build --no-cache

# Or pull the latest base image
docker-compose pull
docker-compose up -d --force-recreate
```

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