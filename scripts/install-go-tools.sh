#!/bin/bash

set -e

echo "🐹 Installing Go tools..."

go_tools=(
    "golang.org/x/tools/gopls@latest"
    "github.com/go-delve/delve/cmd/dlv@latest"
)

echo "Installing essential Go tools in parallel..."
for tool in "${go_tools[@]}"; do
    echo "📦 Installing $tool..."
    go install "$tool" &
done

wait

echo "✅ Go tools installation completed!"