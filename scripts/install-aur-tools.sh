#!/bin/bash

set -e

echo "📦 Installing AUR tools..."

aur_tools=(
    "tfenv"
    "aws-cli-bin"
)

for tool in "${aur_tools[@]}"; do
    yay -S --noconfirm --needed "$tool" || echo "❌ Failed to install $tool"
done

echo "✅ AUR tools installation completed!"