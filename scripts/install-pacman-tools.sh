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
)

sudo pacman -S --noconfirm --needed "${tools[@]}" || echo "❌ Some tools failed to install"
sudo pacman -Scc --noconfirm || true

echo "✅ Pacman tools installation completed!"
