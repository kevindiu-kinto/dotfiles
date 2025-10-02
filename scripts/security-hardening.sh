#!/bin/bash

set -euo pipefail

echo "🔒 Applying security hardening..."

echo "📦 Removing unnecessary packages..."
sudo pacman -Rs --noconfirm \
    man-db \
    man-pages \
    texinfo 2>/dev/null || echo "Some packages already removed"

echo "🛡️ Setting secure permissions..."
sudo chmod 700 /root
sudo chmod 755 /home
chmod 750 /home/dev
chmod 700 /home/dev/.ssh 2>/dev/null || true

echo "🚫 Disabling unnecessary services..."
sudo systemctl disable systemd-resolved 2>/dev/null || true

echo "🔐 Setting secure umask..."
echo "umask 027" | sudo tee -a /etc/profile

echo "✅ Security hardening completed!"