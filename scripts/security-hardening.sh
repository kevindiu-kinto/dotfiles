#!/bin/bash

set -euo pipefail

echo "🔒 Applying security hardening..."

echo "📦 Removing unnecessary packages..."
sudo pacman -Rs --noconfirm \
    man-db \
    man-pages \
    texinfo 2>/dev/null || echo "Some packages already removed"

echo "🚫 Disabling unnecessary services..."
sudo systemctl disable systemd-resolved 2>/dev/null || true

echo "✅ Security hardening completed!"