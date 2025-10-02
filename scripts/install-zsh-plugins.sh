#!/bin/bash

set -euo pipefail

echo "🐚 Installing zsh plugins..."

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

mkdir -p "$ZSH_CUSTOM/plugins"

{
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "🔄 Installing zsh-autosuggestions..."
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo "✅ zsh-autosuggestions installed"
    else
        echo "✅ zsh-autosuggestions already installed"
    fi
} &
{
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "🔄 Installing zsh-syntax-highlighting..."
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo "✅ zsh-syntax-highlighting installed"
    else
        echo "✅ zsh-syntax-highlighting already installed"
    fi
} &

wait
echo "✅ Zsh plugins installation completed!"