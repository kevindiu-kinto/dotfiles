FROM --platform=linux/amd64 archlinux:latest AS base-system

ARG PACKAGES_VERSION=1
ARG TOOLS_VERSION=1
ARG BUILD_DATE
ENV BUILD_DATE=${BUILD_DATE}
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh
ENV TERM=xterm-256color

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN pacman -Sy --noconfirm
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

RUN pacman -S --noconfirm go
RUN pacman -Syu --noconfirm

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay && \
    cd /tmp/yay && \
    makepkg -si --noconfirm && \
    cd / && \
    rm -rf /tmp/yay && \
    yay -Syu --noconfirm

FROM base-system AS tools-installer

COPY --chown=$USERNAME:$USERNAME scripts/install-additional-tools.sh /tmp/
RUN echo "TOOLS_VERSION=${TOOLS_VERSION}" > /tmp/tools.version
RUN chmod +x /tmp/install-additional-tools.sh && /tmp/install-additional-tools.sh
FROM tools-installer AS final

RUN sudo mkdir -p /var/run/sshd && \
    sudo ssh-keygen -A && \
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "$USERNAME:dev" | sudo chpasswd

EXPOSE 22
WORKDIR /workspace
CMD ["sudo", "/usr/sbin/sshd", "-D"]
