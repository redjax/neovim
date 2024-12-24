## Set build arguments with default values
ARG CONTAINER_ENV=1

## Pull nodejs container
FROM node:latest AS node-base
FROM fedora:latest AS fedora-base

## Set environment variables using the ARG values
ENV CONTAINER_ENV=${CONTAINER_ENV}
ENV NEOVIM_MAKE_BUILD_DIR=${NEOVIM_MAKE_BUILD_DIR}

## Update system and install required packages
RUN dnf install -y --setopt=install_weak_deps=False \
        sudo \
        kmod \
        git \
        curl \
        gcc \
        gcc-c++ \
        make \
        ripgrep \
        xclip \
        fzf \
        openssl-devel \
        unzip \
        fontconfig \
        tmux \
        shadow-utils \
        gettext \
    && dnf clean all

## Install Development Libraries group via DNF
RUN dnf group install -y "Development Libraries" \
    && dnf clean all

## Create a non-root user 'neovim' and add to sudo group
RUN useradd -ms /bin/bash neovim && \
    usermod -aG wheel neovim && \
    echo "neovim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/neovim

## Set permissions on neovim home directory
RUN chown -R neovim:neovim /home/neovim \
    && mkdir -pv /home/neovim/.local \
    && chmod -R u+w /home/neovim/.local

## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

## Fedora layer
FROM fedora-base AS fedora-stage

ENV CONTAINER_ENV=1

## Switch to the 'neovim' user
USER neovim

## Copy home directory from previous stage
COPY --from=fedora-base /home/neovim /home/neovim
## Copy the whole repository into the container
COPY --chown=neovim:neovim ./ /neovim-setup
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm

WORKDIR /neovim-setup

## Set temporary paths for nvim to use
ENV XDG_DATA_HOME=/tmp/nvim-data
ENV XDG_STATE_HOME=/tmp/nvim-state

RUN mkdir -p /tmp/nvim-data /tmp/nvim-state

## Run install-neovim-fedora.sh script
RUN chmod +x ./scripts/linux/install.sh && \
    sudo -E CONTAINER_ENV=$CONTAINER_ENV ./scripts/linux/install.sh

## Fedora runtime
FROM fedora-stage AS fedora-runtime

ENV CONTAINER_ENV=1

## Switch to the 'neovim' user
USER neovim

## Copy home directory from previous stage
COPY --from=fedora-stage /home/neovim /home/neovim
## Copy /neovim-setup from previous stage
COPY --from=fedora-stage /neovim-setup /neovim-setup
## Copy nvim binary built from source in previous stage
COPY --from=fedora-stage /usr/local/bin/nvim /usr/local/bin/nvim
## Copy npm binary from the node-base image to this image
COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm
## Copy neovim state & data dirs from previous stage
COPY --from=fedora-stage /tmp/nvim-data /tmp/nvim-data
COPY --from=fedora-stage /tmp/nvim-state /tmp/nvim-state

WORKDIR /neovim-setup

CMD ["sleep", "infinity"]
