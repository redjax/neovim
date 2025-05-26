## Pull nodejs container
FROM node:latest AS node-base
FROM debian:stable-slim AS debian-base

ENV DEBIAN_FRONTEND=noninteractive

## Update system
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-utils \
    sudo \
    kmod \
    git \
    curl \
    build-essential \
    ripgrep \
    xclip \
    git \
    fzf \
    libssl-dev \
    fuse \
    unzip \
    fontconfig \
    tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Enable FUSE support
RUN modprobe fuse

## Create a non-root user 'neovim' and add to sudo group
RUN useradd -ms /bin/bash neovim && \
    usermod -aG sudo neovim && \
    echo "neovim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/neovim

## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

## Debian container
FROM debian-base AS debian-stage

## Switch to the 'neovim' user
USER neovim

## Copy the whole repository into the container
COPY --chown=neovim:neovim ./ /neovim-setup
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

WORKDIR /neovim-setup

## Run install-neovim-deb.sh script
RUN chmod +x ./scripts/linux/install-neovim-deb.sh && \
    sudo ./scripts/linux/install-neovim-deb.sh

RUN ls /usr/local/bin && sleep 15

FROM debian-stage AS debian-runtime

## Switch to the 'neovim' user
USER neovim

## Copy the neovim repository from the stage
# COPY --from=debian-stage /neovim-setup /neovim-setup
## Copy neovim config directory from the stage
COPY --from=debian-stage /home/neovim/.config/nvim /home/neovim/.config/nvim
## Copy neovim binary from the stage
COPY --from=debiann-stage /usr/local/bin/nvim /usr/local/bin/nvim
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm
WORKDIR /neovim-setup

CMD ["sleep", "infinity"]
