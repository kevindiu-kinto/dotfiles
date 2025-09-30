#!/bin/bash
# Go tools installation script
# Install essential Go development tools

set -e

echo "🐹 Installing Go tools..."

# Go tools for development
go_tools=(
    "golang.org/x/tools/gopls@latest"                    # Go language server
    "github.com/go-delve/delve/cmd/dlv@latest"          # Go debugger
)

echo "Installing essential Go tools in parallel..."
for tool in "${go_tools[@]}"; do
    echo "📦 Installing $tool..."
    go install "$tool" &
done

# Wait for all Go tools to install
wait

echo "✅ Go tools installation completed!"