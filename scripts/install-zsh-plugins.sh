#!/bin/bash

set -e

echo "🐚 Installing zsh plugins..."

{
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
} &
{
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
} &

wait
echo "✅ Zsh plugins installation completed!"