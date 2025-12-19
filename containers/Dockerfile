ARG PYTHON_IMG_TAG=${PYTHON_IMG_TAG:-3.13-slim}
ARG GO_IMG_TAG=${GO_IMG_TAG:-1.25.5}
ARG RUST_IMG_TAG=${RUST_IMG_TAG:-latest}

## Language runtime base images
FROM python:${PYTHON_IMG_TAG} AS python-base
FROM golang:${GO_IMG_TAG} AS go-base
FROM rust:${RUST_IMG_TAG} AS rust-base

## Main base image with system dependencies
FROM debian:stable-slim AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    sudo \
    unzip \
    build-essential \
    ripgrep \
    fd-find \
    fzf \
    xclip \
    libssl-dev \
    fontconfig \
    wget \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

## Copy Python from python-base
COPY --from=python-base /usr/local /usr/local

## Copy Go from go-base
COPY --from=go-base /usr/local/go /usr/local/go
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/nvimuser/go"
ENV PATH="${GOPATH}/bin:${PATH}"

## Copy Rust from rust-base  
COPY --from=rust-base /usr/local/cargo /usr/local/cargo
COPY --from=rust-base /usr/local/rustup /usr/local/rustup
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
ENV PATH="${CARGO_HOME}/bin:${PATH}"

## Create symlinks for Python
RUN ln -sf /usr/local/bin/python3 /usr/local/bin/python && \
    ln -sf /usr/local/bin/pip3 /usr/local/bin/pip

## Install pipx for Python tool management
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install pipx && \
    python3 -m pipx ensurepath

## Create a non-root user
RUN useradd -ms /bin/bash nvimuser && \
    echo "nvimuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/nvimuser/.config /home/nvimuser/.local/share /home/nvimuser/.local/state && \
    chown -R nvimuser:nvimuser /home/nvimuser

## Install nvm as nvimuser and set up Node.js
USER nvimuser
WORKDIR /home/nvimuser

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
    export NVM_DIR="/home/nvimuser/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm alias default lts/* && \
    nvm use default

## Set up environment for nvm
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

## Ensure pipx path is available for nvimuser
RUN mkdir -p /home/nvimuser/.local/bin && \
    python3 -m pipx ensurepath

## Set login shell for all RUN commands to load nvm
SHELL ["/bin/bash", "-l", "-c"]

## Build stage - install Neovim and configure
FROM base AS builder
USER nvimuser
WORKDIR /home/nvimuser/neovim

## Copy scripts and configs
COPY --chown=nvimuser:nvimuser scripts/ /home/nvimuser/neovim/scripts/
COPY --chown=nvimuser:nvimuser config/ /home/nvimuser/neovim/config/

## Set build-time config name (default: nvim)
ARG CONFIG_NAME=nvim
ENV CONFIG_NAME=${CONFIG_NAME}
ENV CONTAINER_ENV=1
ENV BUILD_DIR=/tmp/neovim-build

## Make scripts executable
RUN chmod +x scripts/linux/install.sh scripts/linux/install-lsp-requirements.sh scripts/linux/lazy-sync.sh

## Install Neovim from source and create symlinks
RUN ./scripts/linux/install.sh --symlink --build-dir "${BUILD_DIR}"

## Verify nvim was installed
RUN nvim --version

## Install LSP servers and formatters
## Explicitly source nvm to ensure npm is available
RUN source ~/.nvm/nvm.sh && \
    source ~/.bashrc && \
    node --version && \
    npm --version && \
    ./scripts/linux/install-lsp-requirements.sh

## Ensure directories exist for copying later
RUN mkdir -p /home/nvimuser/.local/share/nvim \
    /home/nvimuser/.local/state/nvim \
    /home/nvimuser/go/bin

## Initialize lazy.nvim plugins for the specified config
## Use the config name from build arg
RUN export NVIM_APPNAME="${CONFIG_NAME}" && \
    nvim --headless "+Lazy! sync" +qa || true && \
    nvim --headless "+TSUpdateSync" +qa || true

## Runtime stage
FROM base AS runtime
USER nvimuser
WORKDIR /home/nvimuser/neovim

## Copy installed neovim binary
COPY --from=builder /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=builder /usr/local/share/nvim /usr/local/share/nvim

## Copy neovim configs
COPY --from=builder /home/nvimuser/.config /home/nvimuser/.config

## Copy neovim data (lazy plugins, etc)
COPY --from=builder /home/nvimuser/.local/share/nvim /home/nvimuser/.local/share/nvim
COPY --from=builder /home/nvimuser/.local/state/nvim /home/nvimuser/.local/state/nvim
COPY --from=builder /home/nvimuser/.local/bin /home/nvimuser/.local/bin

## Copy installed LSP servers and tools
COPY --from=builder /home/nvimuser/.nvm /home/nvimuser/.nvm
COPY --from=builder /home/nvimuser/go /home/nvimuser/go

## Copy the repository for reference
COPY --chown=nvimuser:nvimuser . /home/nvimuser/neovim

## Set environment
ENV CONFIG_NAME=${CONFIG_NAME:-nvim}
ENV NVIM_APPNAME=${CONFIG_NAME}

## Add helpful aliases to bashrc
RUN echo 'alias vim="nvim"' >> ~/.bashrc && \
    echo 'alias vi="nvim"' >> ~/.bashrc && \
    echo 'export NVIM_APPNAME="${CONFIG_NAME}"' >> ~/.bashrc && \
    echo 'echo "Neovim config: ${CONFIG_NAME}"' >> ~/.bashrc && \
    echo 'echo "Available configs in ~/.config: $(ls -1 ~/.config | grep nvim)"' >> ~/.bashrc

CMD ["/bin/bash"]
