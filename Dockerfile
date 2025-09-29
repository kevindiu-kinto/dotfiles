# Development Environment - Arch Linux based
FROM archlinux:latest

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color

# Create development user
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# Update system and install base packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
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
        ca-certificates

# Install Go (latest stable)
RUN pacman -S --noconfirm go

# Create user and setup sudo
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to development user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Copy configuration files
COPY --chown=$USERNAME:$USERNAME configs/ /home/$USERNAME/

# Install additional tools (can be easily modified)
COPY --chown=$USERNAME:$USERNAME scripts/install-additional-tools.sh /tmp/
RUN chmod +x /tmp/install-additional-tools.sh && /tmp/install-additional-tools.sh

# Setup SSH for VS Code Remote
RUN sudo mkdir -p /var/run/sshd && \
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "$USERNAME:dev" | sudo chpasswd

# Expose SSH port
EXPOSE 22

# Set working directory for projects
WORKDIR /workspace

# Start SSH daemon and keep container running
CMD ["sudo", "/usr/sbin/sshd", "-D"]