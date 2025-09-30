FROM --platform=linux/amd64 archlinux:latest AS base-system

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

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
        tree \
        htop \
        unzip \
        tar \
        gzip \
        ca-certificates && \
    pacman -Scc --noconfirm

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

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
    echo "$USERNAME:dev" | sudo chpasswd && \
    sudo mv /tmp/start-sshd.sh /usr/local/bin/start-sshd.sh && \
    sudo chmod +x /usr/local/bin/start-sshd.sh

EXPOSE 22
WORKDIR /workspace
CMD ["sudo", "/usr/local/bin/start-sshd.sh"]
