# Configuration Profiles <!-- omit in toc -->

My Neovim configurations. The default configuration in [`nvim`](./nvim/) is my main template. I make best efforts for a cross-platform configuration that will work on Linux and Windows.

Over time, I may add other configurations here, i.e. a "work" configuration, or a simpler configuration with no external dependencies.

## Table of Contents <!-- omit in toc -->

- [nvim (default)](#nvim-default)
  - [Requirements](#requirements)

## Configurations <!-- omit in toc -->

### nvim (default)

My 'default' configuration, built from the [Kickstart.nvim repository](https://github.com/nvim-lua/kickstart.nvim).

#### Requirements

- [Kickstart.nvim dependencies](https://github.com/nvim-lua/kickstart.nvim?tab=readme-ov-file#install-external-dependencies)
  - `git`
  - `make` / `CMake`
  - `unzip`
  - `gcc`
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep#installation)
  - `xclip` / `win32yank`
  - A [Nerd Font](https://www.nerdfonts.com/)
    - The setup scripts install `FiraCode` Nerd Fonts
- `nodejs`/`npm`
  - The setup scripts install `nodejs-lts` with the [Node Version Manager (`nvm`)](https://github.com/nvm-sh/nvm) on Linux, and `nodejs-lts` via [`scoop`](https://scoop.sh) on Windows.
