ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64

FROM --platform=linux/amd64 archlinux:latest AS base-system

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color
ENV MAKEFLAGS=-j$(nproc)
ENV GOCACHE=/home/dev/go/.cache
ENV GOMODCACHE=/home/dev/go/pkg/mod
ENV GOTMPDIR=/tmp/go

ARG USERNAME=dev
ARG USER_UID=${DEV_USER_ID:-1000}
ARG USER_GID=${DEV_GROUP_ID:-1000}

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf && \
    echo 'Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    pacman -Sy --noconfirm && \
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
        ca-certificates && \
    pacman -Scc --noconfirm

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    chmod 750 /home/$USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME

RUN git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay && \
    cd /tmp/yay && \
    makepkg -si --noconfirm && \
    cd / && \
    rm -rf /tmp/yay && \
    yay -Syu --noconfirm

FROM base-system AS pacman-tools

COPY --chown=$USERNAME:$USERNAME scripts/install-pacman-tools.sh /tmp/
RUN chmod +x /tmp/install-pacman-tools.sh && /tmp/install-pacman-tools.sh

FROM pacman-tools AS go-tools

COPY --chown=$USERNAME:$USERNAME scripts/install-go-tools.sh /tmp/
RUN chmod +x /tmp/install-go-tools.sh && /tmp/install-go-tools.sh

FROM go-tools AS zsh-plugins

COPY --chown=$USERNAME:$USERNAME scripts/install-zsh-plugins.sh /tmp/
RUN chmod +x /tmp/install-zsh-plugins.sh && /tmp/install-zsh-plugins.sh

FROM zsh-plugins AS aur-tools

COPY --chown=$USERNAME:$USERNAME scripts/install-aur-tools.sh /tmp/
RUN chmod +x /tmp/install-aur-tools.sh && /tmp/install-aur-tools.sh

FROM aur-tools AS directory-setup

COPY --chown=$USERNAME:$USERNAME scripts/setup-directories.sh /tmp/
RUN chmod +x /tmp/setup-directories.sh && /tmp/setup-directories.sh

FROM directory-setup AS final

COPY --chown=$USERNAME:$USERNAME scripts/start-sshd.sh /tmp/
RUN sudo mkdir -p /var/run/sshd && \
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    echo "$USERNAME:dev" | sudo chpasswd && \
    sudo mv /tmp/start-sshd.sh /usr/local/bin/start-sshd.sh && \
    sudo chmod +x /usr/local/bin/start-sshd.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep sshd || exit 1

EXPOSE 2222
WORKDIR /workspace
CMD ["sudo", "/usr/local/bin/start-sshd.sh"]
