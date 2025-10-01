#!/bin/bash

echo "Starting SSH daemon..."

SSH_KEYS_DIR="/home/dev/.security/ssh-host-keys"
SYSTEM_SSH_DIR="/etc/ssh"

mkdir -p "$SSH_KEYS_DIR"

if [ ! -f "$SSH_KEYS_DIR/ssh_host_rsa_key" ]; then
    echo "Generating SSH host keys in persistent storage..."
    sudo ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_rsa_key" -N '' -t rsa
    sudo ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_ecdsa_key" -N '' -t ecdsa
    sudo ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_ed25519_key" -N '' -t ed25519
else
    echo "SSH host keys already exist, reusing from persistent storage..."
fi

sudo cp "$SSH_KEYS_DIR"/ssh_host_* "$SYSTEM_SSH_DIR/"
sudo chmod 600 "$SYSTEM_SSH_DIR"/ssh_host_*_key
sudo chmod 644 "$SYSTEM_SSH_DIR"/ssh_host_*_key.pub

echo "Starting SSH daemon on port 22..."
exec /usr/sbin/sshd -D