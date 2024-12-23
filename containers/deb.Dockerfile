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

RUN echo "CONTAINER_ENV: ${CONTAINER_ENV}" && echo "NEOVIM_MAKE_BUILD_DIR: ${NEOVIM_MAKE_BUILD_DIR}"


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

## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

## Debian layer
FROM debian-base AS debian-stage

ENV CONTAINER_ENV=1

## Switch to the 'neovim' user
USER neovim

## Copy the whole repository into the container
COPY --chown=neovim:neovim ./ /neovim-setup
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

## Debug print $PWD
# RUN echo "${pwd}" && sleep 2 && ls -la && sleep 5

WORKDIR /neovim-setup

## Set neovim build directory for building from source
#  NOTE: Doesn't seem to work, commenting out to try
#  setting this up again later
# ENV NEOVIM_MAKE_BUILD_DIR="/tmp/build"
# RUN mkdir -pv ${NEOVIM_MAKE_BUILD_DIR}

## Run install-neovim-deb.sh script
RUN chmod +x ./scripts/linux/install.sh && \
    sudo -E CONTAINER_ENV=$CONTAINER_ENV NEOVIM_MAKE_BUILD_DIR=$NEOVIM_MAKE_BUILD_DIR ./scripts/linux/install.sh

# RUN echo "/usr/bin:" && ls /usr/bin && sleep 4 && echo "/usr/local/bin:" && ls /usr/local/bin && sleep 4

RUN $(which nvim) && sleep 5

## Debian runtime
# FROM debian-stage AS debian-runtime

# ENV CONTAINER_ENV=1

## Switch to the 'neovim' user
# USER neovim

# COPY --from=debian-stage /neovim-setup /neovim-setup
# COPY --from=debian-stage /usr/local/bin /usr/local/bin
# COPY --from=debian-stage /usr/bin /usr/bin

## Copy the neovim repository from the stage
# COPY --from=debian-stage /neovim-setup /neovim-setup
## Copy neovim config directory from the stage
# COPY --from=debian-stage /home/neovim/.config/nvim /home/neovim/.config/nvim
## Copy neovim binary from the stage
# COPY --from=debian-stage /usr/local/bin/nvim /usr/local/bin/nvim
## Copy npm binary from the node-base image to this image
# COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm
# WORKDIR /neovim-setup

# CMD ["sleep", "infinity"]

## Fedora layer
