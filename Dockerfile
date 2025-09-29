# Multi-stage build for better caching
# Stage 1: Base system with packages (cached aggressively)
FROM --platform=linux/amd64 archlinux:latest AS base-system

# Build arguments for selective cache busting
ARG PACKAGES_VERSION=1
ARG TOOLS_VERSION=1
ARG BUILD_DATE
ENV BUILD_DATE=${BUILD_DATE}

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color

# Create development user
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# Update package database first (separate layer for better caching)
RUN pacman -Sy --noconfirm

# Install base packages (cached layer if no package changes)
RUN pacman -S --noconfirm \
        base-devel \
        git \
        curl \
        wget \
        vim \
        zsh \
        tmux \
        openssh \
        sudo \
        which \
        tree \
        htop \
        unzip \
        tar \
        gzip \
        ca-certificates \
        github-cli \
        gnupg

# Install Go (separate layer for better caching)
RUN pacman -S --noconfirm go

# Update all packages to latest versions (this layer will rebuild when packages update)
RUN pacman -Syu --noconfirm

# Create user and setup sudo
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to development user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install yay (AUR helper) - separate layer for better caching
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay && \
    cd /tmp/yay && \
    makepkg -si --noconfirm && \
    cd / && \
    rm -rf /tmp/yay && \
    yay -Syu --noconfirm

# Copy configuration files (this layer changes frequently)
COPY --chown=$USERNAME:$USERNAME configs/ /home/$USERNAME/

# Stage 2: Install expensive tools (cached separately)
FROM base-system AS tools-installer

# Copy tools installation script with version for cache control
COPY --chown=$USERNAME:$USERNAME scripts/install-additional-tools.sh /tmp/
RUN echo "TOOLS_VERSION=${TOOLS_VERSION}" > /tmp/tools.version
RUN chmod +x /tmp/install-additional-tools.sh && /tmp/install-additional-tools.sh

# Stage 3: Final image with configs (frequently changing)
FROM tools-installer AS final

# Setup SSH for VS Code Remote
RUN sudo mkdir -p /var/run/sshd && \
    sudo ssh-keygen -A && \
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "$USERNAME:dev" | sudo chpasswd

# Expose SSH port
EXPOSE 22

# Set working directory for projects
WORKDIR /workspace

# Start SSH daemon and keep container running
CMD ["sudo", "/usr/sbin/sshd", "-D"]
