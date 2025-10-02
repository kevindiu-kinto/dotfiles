#!/bin/bash

set -euo pipefail

echo "🚀 Starting SSH daemon..."

SSH_KEYS_DIR="/home/dev/.security/ssh-host-keys"
SYSTEM_SSH_DIR="/etc/ssh"

# Ensure SSH keys directory exists
mkdir -p "$SSH_KEYS_DIR"

# Generate SSH host keys if they don't exist
if [ ! -f "$SSH_KEYS_DIR/ssh_host_rsa_key" ]; then
    echo "🔑 Generating SSH host keys in persistent storage..."
    
    if sudo ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_rsa_key" -N '' -t rsa && \
       sudo ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_ecdsa_key" -N '' -t ecdsa && \
       sudo ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_ed25519_key" -N '' -t ed25519; then
        echo "✅ SSH host keys generated successfully"
    else
        echo "❌ Failed to generate SSH host keys"
        exit 1
    fi
else
    echo "✅ SSH host keys already exist, reusing from persistent storage..."
fi

# Copy keys to system location
echo "📋 Copying SSH host keys to system directory..."
if sudo cp "$SSH_KEYS_DIR"/ssh_host_* "$SYSTEM_SSH_DIR/" && \
   sudo chmod 600 "$SYSTEM_SSH_DIR"/ssh_host_*_key && \
   sudo chmod 644 "$SYSTEM_SSH_DIR"/ssh_host_*_key.pub; then
    echo "✅ SSH host keys configured successfully"
else
    echo "❌ Failed to configure SSH host keys"
    exit 1
fi

echo "🌐 Starting SSH daemon on port 2222..."
exec /usr/sbin/sshd -D