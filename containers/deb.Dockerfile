## Set build arguments with default values
ARG CONTAINER_ENV=1
ARG NEOVIM_MAKE_BUILD_DIR=/tmp/build

## Pull nodejs container
FROM node:latest AS node-base
FROM debian:stable-slim AS debian-base

## Set environment variables using the ARG values
ENV CONTAINER_ENV=${CONTAINER_ENV}
ENV NEOVIM_MAKE_BUILD_DIR=${NEOVIM_MAKE_BUILD_DIR}

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
        unzip \
        fontconfig \
        tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Create a non-root user 'neovim' and add to sudo group
RUN useradd -ms /bin/bash neovim && \
    usermod -aG sudo neovim && \
    echo "neovim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/neovim

## Set permissions on neovim home directory
RUN chown -R neovim:neovim /home/neovim \
    && mkdir -pv /home/neovim/.local \
    && chmod -R u+w /home/neovim/.local

## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

## Debian layer
FROM debian-base AS debian-stage

ENV CONTAINER_ENV=1

## Switch to the 'neovim' user
USER neovim

## Copy home directory from previous stage
COPY --from=debian-base /home/neovim /home/neovim
## Copy the whole repository into the container
COPY --chown=neovim:neovim ./ /neovim-setup
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

WORKDIR /neovim-setup

## Run install-neovim-deb.sh script
RUN chmod +x ./scripts/linux/install.sh && \
    sudo -E CONTAINER_ENV=$CONTAINER_ENV NEOVIM_MAKE_BUILD_DIR=$NEOVIM_MAKE_BUILD_DIR ./scripts/linux/install.sh

## Set temporary paths for nvim to use
ENV XDG_DATA_HOME=/tmp/nvim-data
ENV XDG_STATE_HOME=/tmp/nvim-state

RUN mkdir -p /tmp/nvim-data /tmp/nvim-state

## Debian runtime
FROM debian-stage AS debian-runtime

ENV CONTAINER_ENV=1

## Switch to the 'neovim' user
USER neovim

## Copy home directory from previous stage
COPY --from=debian-stage /home/neovim /home/neovim
## Copy /neovim-setup from previous stage
COPY --from=debian-stage /neovim-setup /neovim-setup
## Copy nvim binary built from source in previous stage
COPY --from=debian-stage /usr/local/bin/nvim /usr/local/bin/nvim
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm
## Copy neovim state & data dirs from previous stage
COPY --from=debian-stage /tmp/nvim-data /tmp/nvim-data
COPY --from=debian-stage /tmp/nvim-state /tmp/nvim-state

WORKDIR /neovim-setup

CMD ["sleep", "infinity"]

## Fedora layer
