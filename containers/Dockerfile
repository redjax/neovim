ARG PYTHON_IMG_TAG=${PYTHON_IMG_TAG:-3.12-slim}
ARG NODE_IMG_TAG=${NODE_IMG_TAG:-latest}
## Add layer for Python
FROM python:${PYTHON_IMG_TAG} AS python-base
## Add layer for Node
# FROM node:${NODE_IMG_TAG} AS node-base

FROM debian:stable-slim AS base
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    sudo \
    unzip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

## Copy node, npm, python, and pip from previous stages
# COPY --from=node-base /usr/local/bin/node /usr/local/bin/node
# COPY --from=node-base /usr/local/bin/npm /usr/local/bin/npm
COPY --from=python-base /usr/local/bin/python3 /usr/local/bin/python3
COPY --from=python-base /usr/local/bin/pip3 /usr/local/bin/pip3

## symlink python and pip for convenience
RUN ln -sf /usr/local/bin/python3 /usr/local/bin/python
RUN ln -sf /usr/local/bin/pip3 /usr/local/bin/pip

## Create a non-root user (rarely changes)
RUN useradd -ms /bin/bash nvimuser && echo "nvimuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Install nvm as nvimuser and set up .bashrc
USER nvimuser
WORKDIR /home/nvimuser
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
    export NVM_DIR="/home/nvimuser/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm alias default lts/*
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

## Set login mode for Bash shells, subsequent layers will now have nvm, node/npm,
#  and Python/pip
SHELL ["/bin/bash", "-l", "-c"]

FROM base AS scripts
USER nvimuser
WORKDIR /home/nvimuser/neovim

# Copy only the scripts and config directories
COPY --chown=nvimuser:nvimuser scripts/ /home/nvimuser/neovim/scripts/
COPY --chown=nvimuser:nvimuser config/ /home/nvimuser/neovim/config/

# Set build-time config name (default: nvim)
ARG CONFIG_NAME=nvim
ENV CONFIG_NAME=${CONFIG_NAME}
ENV CONTAINER_ENV=1

# Make scripts executable
RUN chmod +x scripts/linux/install.sh scripts/linux/install-lsp-requirements.sh

FROM scripts AS installation
# Run the install scripts
RUN ./scripts/linux/install.sh "$CONFIG_NAME" && \
    ./scripts/linux/install-lsp-requirements.sh

FROM installation AS run
# Copy the rest of the repo (won't affect cache for previous stages)
COPY --chown=nvimuser:nvimuser . /home/nvimuser/neovim

CMD ["/bin/bash"]
