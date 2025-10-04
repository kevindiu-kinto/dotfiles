#!/bin/bash

set -euo pipefail

echo "📦 Installing pacman tools..."

tools=(
    "ripgrep"
    "fd"
    "bat"
    "exa"
    "fzf"
    "jq"
    "yq"
    "lazygit"
    "docker"
    "docker-compose"
    "github-cli"
    "gnupg"
    "go"
    "nodejs"
    "npm"
    "kubectl"
    "helm"
)

echo "🔄 Installing ${#tools[@]} pacman tools..."
sudo pacman -S --noconfirm --needed "${tools[@]}"

echo "🧹 Cleaning package cache..."
sudo pacman -Scc --noconfirm || true

echo "🔧 Enabling corepack..."
sudo corepack enable || echo "⚠️  Failed to enable corepack (non-critical)"

echo "✅ Pacman tools installation completed!"
