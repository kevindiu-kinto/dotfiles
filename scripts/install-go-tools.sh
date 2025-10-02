#!/bin/bash

set -euo pipefail

echo "🐹 Installing Go tools..."

go_tools=(
    "golang.org/x/tools/gopls@latest"
    "github.com/go-delve/delve/cmd/dlv@latest"
)

for tool in "${go_tools[@]}"; do
    echo "🔄 Installing $tool..."
    go install "$tool" &
done

wait
echo "✅ Go tools installation completed!"