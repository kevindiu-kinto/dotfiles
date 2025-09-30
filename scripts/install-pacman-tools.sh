#!/bin/bash
# Pacman tools installation script
# Install CLI tools via pacman package manager

set -e

echo "📦 Installing pacman tools..."

# Define tools to install
tools=(
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
    "docker"           # Docker CLI
    "docker-compose"   # Docker Compose
)

echo "🔧 Installing CLI tools in batch..."
sudo pacman -S --noconfirm --needed "${tools[@]}" || echo "❌ Some tools failed to install"

# Clean package cache to reduce image size
echo "🧹 Cleaning package cache..."
sudo pacman -Scc --noconfirm || true

echo "✅ Pacman tools installation completed!"
