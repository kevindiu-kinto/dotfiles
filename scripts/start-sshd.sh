#!/bin/bash

# SSH Daemon Startup Script
# Generates SSH host keys only if they don't exist (for persistence)

echo "Starting SSH daemon..."

# Generate SSH host keys only if they do not exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
else
    echo "SSH host keys already exist, reusing..."
fi

# Start SSH daemon
echo "Starting SSH daemon on port 22..."
exec /usr/sbin/sshd -D