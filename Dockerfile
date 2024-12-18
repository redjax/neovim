FROM debian:stable-slim AS base

ENV DEBIAN_FRONTEND=noninteractive

## Update system
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Create a non-root user 'neovim' and add to sudo group
RUN useradd -ms /bin/bash neovim && \
    usermod -aG sudo neovim && \
    echo "neovim ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/neovim

FROM base AS stage

## Switch to the 'neovim' user
USER neovim

## Copy the whole repository into the container
COPY --chown=neovim:neovim ./ /neovim-setup

WORKDIR /neovim-setup

## Give neovim user passwordless sudo permissions
RUN echo "neovim ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Run install-neovim-deb.sh script
RUN chmod +x ./scripts/linux/install-neovim-deb.sh && \
    sudo ./scripts/linux/install-neovim-deb.sh

FROM stage AS runtime

## Switch to the 'neovim' user
USER neovim

COPY --from=stage /neovim-setup /neovim-setup
WORKDIR /neovim-setup

CMD ["echo", "Neovim setup complete."]
