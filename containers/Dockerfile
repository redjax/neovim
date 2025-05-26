FROM debian:stable-slim AS base
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    sudo \
    unzip \
    && rm -rf /var/lib/apt/lists/*

## Create a non-root user (rarely changes)
RUN useradd -ms /bin/bash nvimuser && echo "nvimuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

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
