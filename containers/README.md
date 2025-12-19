# Neovim Container Testing <!--omit in toc -->

This directory contains Docker configurations for testing your Neovim setups in isolated environments.

## Table of Contents <!-- omit in toc -->

- [Neovim Container Testing ](#neovim-container-testing-)
  - [Quick Start](#quick-start)
    - [Build and run a specific config](#build-and-run-a-specific-config)
    - [Using the container](#using-the-container)
  - [Build Arguments](#build-arguments)
  - [Testing Different Configs](#testing-different-configs)
  - [Troubleshooting](#troubleshooting)
    - [Plugins not loading?](#plugins-not-loading)
    - [LSP servers missing?](#lsp-servers-missing)
    - [Rebuild from scratch](#rebuild-from-scratch)
  - [Advanced Usage](#advanced-usage)
    - [Interactive plugin testing](#interactive-plugin-testing)
    - [Mount local config for live development](#mount-local-config-for-live-development)
  - [Notes](#notes)

## Quick Start

### Build and run a specific config

```bash
## From the repository root
cd containers

## Test the default nvim config
docker compose build
docker compose run --rm nvim

## Test nvim-lazyvim config
CONFIG_NAME=nvim-lazyvim docker compose build
CONFIG_NAME=nvim-lazyvim docker compose run --rm nvim

## Test nvim-work config
CONFIG_NAME=nvim-work docker compose build
CONFIG_NAME=nvim-work docker compose run --rm nvim
```

### Using the container

Once inside the container:

```bash
## Neovim is ready to use with your config
nvim

## Check which config is active
echo $NVIM_APPNAME

## View installed LSP servers
npm list -g --depth=0  # Node-based servers
pip list               # Python-based servers
ls ~/go/bin            # Go-based tools
cargo install --list   # Rust-based tools

## Run lazy.nvim operations
nvim --headless "+Lazy! sync" +qa
nvim --headless "+Lazy! update" +qa
```

## Build Arguments

You can customize the container with build args:

```bash
## Use specific language versions
docker compose build \
  --build-arg PYTHON_IMG_TAG=3.11-slim \
  --build-arg GO_IMG_TAG=1.20 \
  --build-arg RUST_IMG_TAG=1.75
```

Or set them in `.env`:

```bash
cp .env.example .env
# Edit .env with your preferences
docker compose build
```

## Testing Different Configs

To test all your configs:

```bash
# Test nvim
CONFIG_NAME=nvim docker compose build && CONFIG_NAME=nvim docker compose run --rm nvim

# Test nvim-lazyvim
CONFIG_NAME=nvim-lazyvim docker compose build && CONFIG_NAME=nvim-lazyvim docker compose run --rm nvim

# Test nvim-work
CONFIG_NAME=nvim-work docker compose build && CONFIG_NAME=nvim-work docker compose run --rm nvim
```

## Troubleshooting

### Plugins not loading?

```bash
# Inside container, manually sync plugins
export NVIM_APPNAME=your-config-name
nvim --headless "+Lazy! restore" +qa
```

### LSP servers missing?

```bash
# Re-run the LSP requirements script
cd /home/nvimuser/neovim
./scripts/linux/install-lsp-requirements.sh
```

### Rebuild from scratch

```bash
docker compose down -v
docker compose build --no-cache
```

## Advanced Usage

### Interactive plugin testing

```bash
# Start container
docker compose run --rm nvim

# Inside container, test lazy.nvim
nvim
:Lazy
:Mason
:checkhealth
```

### Mount local config for live development

Edit `compose.yml` and uncomment the volume mount:

```yaml
volumes:
  - ../config/${CONFIG_NAME:-nvim}:/home/nvimuser/.config/${CONFIG_NAME:-nvim}
```

Then your local config changes will reflect immediately in the container.

## Notes

- The container runs as user `nvimuser` (non-root)
- Neovim is built from source (latest stable)
- All configs are symlinked to `~/.config/`
- Plugin data is stored in `~/.local/share/nvim`
- Go tools are in `~/go/bin`
- nvm manages Node.js in `~/.nvm`
