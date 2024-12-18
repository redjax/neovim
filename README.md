# Neovim Configuration <!-- omit in toc -->

![GitHub Created At](https://img.shields.io/github/created-at/redjax/neovim)
![GitHub last commit](https://img.shields.io/github/last-commit/redjax/neovim)
![GitHub commits this year](https://img.shields.io/github/commit-activity/y/redjax/neovim)
![GitHub repo size](https://img.shields.io/github/repo-size/redjax/neovim)
<!-- ![GitHub Latest Release](https://img.shields.io/github/release-date/redjax/neovim) -->
<!-- ![GitHub commits since latest release](https://img.shields.io/github/commits-since/redjax/neovim/latest) -->
<!-- ![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/redjax/neovim/tests.yml) -->

My `neovim` configuration as a git repository.

```
NOTE
----

Until this message is removed, this repository is considered unstable.

I am developing my Neovim configuration based on the Kickstart.nvim template, but am still in the early stages of developing it.
```

## Table of Contents <!-- omit in toc -->

- [Requirements](#requirements)
- [Instructions](#instructions)
  - [Linux](#linux)
  - [Windows](#windows)
- [Notes](#notes)
- [Links](#links)

## Requirements

If you install `neovim` using one of the [install/setup scripts](./scripts/), the dependencies for my `neovim` configuration will be installed automatically.

Otherwise, requirements for this configuration are:

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

## Instructions

- Clone repository with `git clone git@github.com:redjax/neovim` (or with HTTPS: `git clone https://github.com/redjax/neovim ./neovim`)
- Run the setup script for your platform:
  - [Linux](#linux)
  - [Windows](#windows)
- Run `nvim` to ensure everything installed correctly.

### Linux

The Linux setup scripts install & configure `neovim` and any dependencies needed to build/configure/run the program. The script also creates a symlink of the [`config/nvim`](./config/nvim) profile at `~/.config/nvim`.

- Debian-based OSes (Debian, Ubuntu, etc)
  - Run [`./scripts/linux/install-neovim-deb.sh`](./scripts/linux/install-neovim-deb.sh)

### Windows

The [Windows setup script](./scripts/windows/install-neovim-win.ps1) installs the [`scoop` package manager](https://scoop.sh), then installs all `neovim` requirements (including `nodejs-lts`) with it. `neovim` itself is installed with `scoop` using this script.

I chose `scoop` over other options like `winget` and `chocolatey` because every dependency I need is there, the setup is simple, and it keeps everything contained to a path instead of throwing shit all over the OS's `$PATH`.

- Run [`./scripts/windows/install-neovim-win.ps1`](./scripts/windows/install-neovim-win.ps1)
  - **NOTE**: Windows requires Administrator priviliges to create path junctions. If you use the [Windows setup script](./scripts/windows/install-neovim-win.ps1), the junction will call the `Run-AsAdmin` command if the script is not running in an elevated session; you may see a UAC prompt, have to type a password, or you might see a blue Powershell window flash on the screen for a moment.

## Notes

- View available colorschemes by opening neovim and running `:Telescope colorscheme`
- Press `<Space>` to open an interactive menu
- Run `:Lazy` to open the package manager

## Links

- [Github: kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [Github: lazy.nvim](https://github.com/folke/lazy.nvim)
- [LazyVim Docs](https://lazy.folke.io)
