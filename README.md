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
- Run one of the [setup scripts](./scripts/)
  - Linux:
    - (Debian, Ubuntu, etc): [`./scripts/linux/install-neovim-deb.sh`](./scripts/linux/install-neovim-deb.sh)
  - Windows:
    - [`./scripts/windows/install-neovim-win.ps1`](./scripts/windows/install-neovim-win.ps1)
- Create a symbolic link of [`config/nvim`](./config/nvim) at:
  - (Linux): `$HOME/.config/nvim`
    - `ln -l /path/to/this-repo/config/nvim $HOME/.config/nvim`
  - (Windows PowerShell): `$env:LOCALAPPDATA\nvim`
    - `cmd /c mklink /J "C:\path\to\this-repo\config\nvim" "$env:LOCALAPPDATA\nvim"`
- Run `nvim` from the root of this repository
  - The first time you run `nvim`, the Lazy plugin installer will run and do the environment setup.
  - You should run this from this repository, in the same path as [`lazy-lock.json`](./lazy-lock.json).
    - This ensures that the installer installs the plugin versions known to be compatible with this repository.
    - I will make an effort to ensure the `main` branch of this repository is always in a "working" state.
- More to come...

## Notes

## Links

- [Github: kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
