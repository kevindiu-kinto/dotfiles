#!/bin/bash

set -euo pipefail

install_gui() {
    echo "�️  Installing VNC server and desktop environment..."
    
    # Install VNC server and lightweight XFCE desktop
    echo "📦 Installing packages..."
    pacman -S --needed --noconfirm \
        tigervnc \
        python-pip \
        python-numpy \
        xfce4 \
        xfce4-terminal \
        xfce4-taskmanager \
        xorg-server \
        xorg-xinit \
        xorg-xauth \
        xorg-xhost \
        dbus \
        firefox \
        thunar \
        git

    # Install websockify via pip
    echo "🐍 Installing websockify..."
    pip install --break-system-packages websockify

    # Clone noVNC for web-based access
    echo "🌐 Installing noVNC..."
    if [ ! -d /opt/noVNC ]; then
        git clone --depth 1 https://github.com/novnc/noVNC.git /opt/noVNC
    fi

    # Setup VNC directory for dev user
    echo "🔧 Configuring VNC..."
    runuser -u dev -- mkdir -p /home/dev/.vnc

    # Create VNC password (default: dev)
    echo "dev" | runuser -u dev -- vncpasswd -f > /home/dev/.vnc/passwd
    chmod 600 /home/dev/.vnc/passwd
    chown dev:dev /home/dev/.vnc/passwd

    # Create VNC startup script
    cat > /home/dev/.vnc/xstartup << 'EOF'
#!/bin/bash

# Disable session manager
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Start D-Bus session and export variables
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
    export DBUS_SESSION_BUS_PID
fi

# Set background
xsetroot -solid grey &

# Start window manager first
xfwm4 --compositor=off &

# Wait for window manager to start
sleep 1

# Start panel
xfce4-panel &

# Start terminal
xfce4-terminal &

# Keep session alive
wait
EOF
    chmod +x /home/dev/.vnc/xstartup
    chown dev:dev /home/dev/.vnc/xstartup

    # Create VNC config
    cat > /home/dev/.vnc/config << 'EOF'
geometry=1920x1080
depth=24
dpi=96
localhost=no
alwaysshared
session=custom
EOF
    chown dev:dev /home/dev/.vnc/config

    # Create custom session desktop file
    mkdir -p /usr/share/xsessions
    cat > /usr/share/xsessions/custom.desktop << 'EOF'
[Desktop Entry]
Name=Custom VNC Session
Comment=Lightweight session with window manager
Exec=/home/dev/.vnc/xstartup
Type=Application
EOF

    echo ""
    echo "✅ GUI installation completed!"
}

check_and_install_gui() {
    echo "🔍 Checking GUI installation..."
    
    # Check if VNC and GUI components are installed
    if ! command -v vncserver &> /dev/null || \
       ! command -v xfwm4 &> /dev/null || \
       ! command -v xfce4-terminal &> /dev/null || \
       ! [ -d /opt/noVNC ]; then
        echo "📦 GUI components not found. Installing..."
        echo ""
        
        # Run installation
        install_gui
    else
        echo "✅ GUI components already installed"
    fi
    echo ""
}

start_vnc() {
    echo "🚀 Starting VNC server..."
    
    # Check and install GUI if needed
    check_and_install_gui
    
    # Kill existing processes
    runuser -u dev -- vncserver -kill :1 2>/dev/null || true
    pkill -f "websockify.*6080" 2>/dev/null || true
    sleep 1
    
    # Start VNC server as dev user in background
    runuser -u dev -- bash -c 'nohup vncserver :1 > /tmp/vncserver.log 2>&1 &'
    sleep 3
    
    # Check if VNC started
    if ! ps aux | grep -q "[X]vnc :1"; then
        echo "❌ VNC server failed to start"
        echo "Log:"
        runuser -u dev -- cat /tmp/vncserver.log 2>/dev/null || echo "No log file"
        exit 1
    fi
    
    # Start websockify
    runuser -u dev -- bash -c 'nohup websockify --web=/opt/noVNC 6080 localhost:5901 > /tmp/websockify.log 2>&1 &'
    sleep 2
    
    echo "✅ VNC server started successfully!"
    echo ""
    echo "📺 Access options:"
    echo "  • Web Browser: http://localhost:6080/vnc.html"
    echo "  • VNC Client:  vnc://localhost:5901"
    echo "  • Password:    dev"
}

stop_vnc() {
    echo "🛑 Stopping VNC server..."
    runuser -u dev -- vncserver -kill :1 2>/dev/null || true
    pkill -f "websockify.*6080" 2>/dev/null || true
    echo "✅ VNC server stopped"
}

case "${1:-}" in
    start)
        start_vnc
        ;;
    stop)
        stop_vnc
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
