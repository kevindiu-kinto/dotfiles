FROM --platform=linux/arm64 manjarolinux/base:latest AS base-system

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color
ENV MAKEFLAGS=-j$(nproc)

ARG USERNAME=dev
ARG USER_UID=${DEV_USER_ID:-1001}
ARG USER_GID=${DEV_GROUP_ID:-1001}

RUN --mount=type=cache,target=/var/cache/pacman/pkg --mount=type=cache,target=/tmp \
    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN pacman -Sy --noconfirm && \
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
        yay \
        ca-certificates && \
    pacman -Scc --noconfirm

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    chmod 750 /home/$USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME

RUN --mount=type=cache,target=/home/$USERNAME/.cache,uid=$USER_UID,gid=$USER_GID \
    yay -Sy --noconfirm

FROM base-system AS tools

COPY --chown=$USERNAME:$USERNAME scripts/install-aur-tools.sh /tmp/
RUN --mount=type=cache,target=/home/$USERNAME/.cache/yay,uid=$USER_UID,gid=$USER_GID --mount=type=cache,target=/home/$USERNAME/.cache/makepkg,uid=$USER_UID,gid=$USER_GID \
    chmod +x /tmp/install-aur-tools.sh && /tmp/install-aur-tools.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-pacman-tools.sh /tmp/
RUN --mount=type=cache,target=/var/cache/pacman/pkg --mount=type=cache,target=/home/$USERNAME/.npm,uid=$USER_UID,gid=$USER_GID \
    chmod +x /tmp/install-pacman-tools.sh && /tmp/install-pacman-tools.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-go-tools.sh /tmp/
RUN --mount=type=cache,target=/home/$USERNAME/go,uid=$USER_UID,gid=$USER_GID \
    chmod +x /tmp/install-go-tools.sh && /tmp/install-go-tools.sh

COPY --chown=$USERNAME:$USERNAME scripts/install-zsh-plugins.sh /tmp/
RUN chmod +x /tmp/install-zsh-plugins.sh && /tmp/install-zsh-plugins.sh

FROM tools AS final

COPY --chown=$USERNAME:$USERNAME scripts/setup-directories.sh /tmp/
RUN chmod +x /tmp/setup-directories.sh && /tmp/setup-directories.sh

USER root
COPY scripts/start-sshd.sh /tmp/start-sshd.sh
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN install -o root -g root -m 755 /tmp/start-sshd.sh /usr/local/bin/start-sshd.sh && \
    rm /tmp/start-sshd.sh

EXPOSE 2222
WORKDIR /workspace
CMD ["/usr/local/bin/start-sshd.sh"]
