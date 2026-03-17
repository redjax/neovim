ARG PYTHON_IMG_TAG=${PYTHON_IMG_TAG:-3.13-slim}
ARG GO_IMG_TAG=${GO_IMG_TAG:-1.25.5}
ARG RUST_IMG_TAG=${RUST_IMG_TAG:-latest}
ARG BASE_IMAGE=${BASE_IMAGE:-debian:stable-slim}

## Language runtime base images (for copying toolchains)
FROM python:${PYTHON_IMG_TAG} AS python-base
FROM golang:${GO_IMG_TAG} AS go-base
FROM rust:${RUST_IMG_TAG} AS rust-base

## -----------------------------------------------------------
## Single-stage build: simulates a fresh install on a target distro
## so the install scripts run exactly like they would on a host.
##
## Set BASE_IMAGE to test different distros:
##   debian:stable-slim, ubuntu:24.04, fedora:41, archlinux:base, alpine:3.21
## -----------------------------------------------------------
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

## Bootstrap: install the bare minimum (curl, git, sudo, bash, openssl libs)
## so the install scripts can take over. Detects the package manager automatically.
## OpenSSL libs are needed because the Python binaries copied from python-base
## are linked against them, and different distros place them at different paths.
RUN set -e; \
    if command -v apt-get >/dev/null 2>&1; then \
        apt-get update && apt-get install -y --no-install-recommends \
            ca-certificates curl git sudo unzip wget bash libssl-dev && \
        rm -rf /var/lib/apt/lists/*; \
    elif command -v dnf >/dev/null 2>&1; then \
        dnf install -y ca-certificates curl git sudo unzip wget bash \
            openssl-devel openssl-libs && \
        dnf clean all; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y ca-certificates curl git sudo unzip wget bash \
            openssl-devel openssl-libs && \
        yum clean all; \
    elif command -v pacman >/dev/null 2>&1; then \
        pacman -Syu --noconfirm ca-certificates curl git sudo unzip wget bash openssl && \
        pacman -Scc --noconfirm; \
    elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache ca-certificates curl git sudo unzip wget bash shadow openssl-dev; \
    else \
        echo "ERROR: Unsupported base image — no known package manager found"; \
        exit 1; \
    fi

## Copy language toolchains so LSP requirement scripts can use them
## Copy Python selectively (COPY /usr/local /usr/local breaks on distros
## where /usr/local/sbin is a symlink, e.g. Fedora)
COPY --from=python-base /usr/local/bin/ /usr/local/bin/
COPY --from=python-base /usr/local/lib/ /usr/local/lib/
COPY --from=python-base /usr/local/include/ /usr/local/include/
COPY --from=go-base /usr/local/go /usr/local/go
COPY --from=rust-base /usr/local/cargo /usr/local/cargo
COPY --from=rust-base /usr/local/rustup /usr/local/rustup

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/nvimuser/go"
ENV PATH="${GOPATH}/bin:${PATH}"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
ENV PATH="${CARGO_HOME}/bin:${PATH}"

## Create symlinks for Python
RUN ln -sf /usr/local/bin/python3 /usr/local/bin/python && \
    ln -sf /usr/local/bin/pip3 /usr/local/bin/pip

## Install pipx
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install pipx && \
    python3 -m pipx ensurepath

## Create a non-root user (simulates a regular user account)
RUN useradd -ms /bin/bash nvimuser && \
    echo "nvimuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/nvimuser/.config /home/nvimuser/.local/share /home/nvimuser/.local/state && \
    chown -R nvimuser:nvimuser /home/nvimuser

## Install nvm + Node.js as nvimuser
USER nvimuser
WORKDIR /home/nvimuser

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
    export NVM_DIR="/home/nvimuser/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm alias default lts/* && \
    nvm use default

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

RUN mkdir -p /home/nvimuser/.local/bin && \
    python3 -m pipx ensurepath

## Use login shell so nvm is available in subsequent RUN steps
SHELL ["/bin/bash", "-l", "-c"]

## -----------------------------------------------------------
## Copy the repository in and run the install scripts
## This mirrors: git clone → cd neovim → ./scripts/linux/install.sh
## -----------------------------------------------------------
WORKDIR /home/nvimuser/neovim
COPY --chown=nvimuser:nvimuser . /home/nvimuser/neovim/

ARG CONFIG_NAME=nvim
ENV CONFIG_NAME=${CONFIG_NAME}
ENV CONTAINER_ENV=1

## Make scripts executable
RUN chmod +x scripts/linux/*.sh

## Run install.sh exactly as you would on a fresh host
## --symlink creates ~/.config/<config> symlinks pointing at the repo
RUN ./scripts/linux/install.sh --symlink --build-dir /tmp/neovim-build

## Verify neovim installed correctly
RUN nvim --version

## Install LSP servers and formatters (uses npm, pip, go, cargo)
RUN source ~/.nvm/nvm.sh && \
    ./scripts/linux/install-lsp-requirements.sh

## Sync lazy.nvim plugins for the selected config
RUN export NVIM_APPNAME="${CONFIG_NAME}" && \
    nvim --headless "+Lazy! sync" +qa && \
    nvim --headless "+TSUpdateSync" +qa || true

## -----------------------------------------------------------
## Runtime environment
## -----------------------------------------------------------
ENV NVIM_APPNAME=${CONFIG_NAME}

RUN echo 'alias vim="nvim"' >> ~/.bashrc && \
    echo 'alias vi="nvim"' >> ~/.bashrc && \
    echo "export NVIM_APPNAME=\"${CONFIG_NAME}\"" >> ~/.bashrc && \
    echo "echo \"Neovim config: ${CONFIG_NAME}\"" >> ~/.bashrc && \
    echo 'echo "Available configs in ~/.config: $(ls -1 ~/.config | grep nvim)"' >> ~/.bashrc

CMD ["/bin/bash"]
