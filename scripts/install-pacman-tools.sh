#!/bin/bash

set -e

echo "📦 Installing pacman tools..."

tools=(
    "ripgrep"
    "fd"
    "bat"
    "exa"
    "fzf"
    "jq"
    "yq"
    "httpie"
    "ncdu"
    "lazygit"
    "docker"
    "docker-compose"
    "github-cli"
    "gnupg"
    "go"
    "nodejs"
    "npm"
    "zip"
)

sudo pacman -S --noconfirm --needed "${tools[@]}" || echo "❌ Some tools failed to install"
sudo pacman -Scc --noconfirm || true

echo "🔧 Enabling corepack..."
sudo corepack enable || echo "❌ Failed to enable corepack"

echo "✅ Pacman tools installation completed!"
