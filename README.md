# Neovim Configuration <!-- omit in toc -->

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
    - (Debian, Ubuntu, etc): [`./scripts/linux/install-neovim-deb.sh](./scripts/linux/install-neovim-deb.sh)
  - Windows:
    - [`./scripts/windows/install-neovim-win.ps1`](./scripts/windows/install-neovim-win.ps1)
- Create a symbolic link of [`config/nvim`](./config/nvim) at:
  - (Linux): `$HOME/.config/nvim`
  - (Windows): `$env:USERPROFILE/.config/nvim`
- More to come...

## Notes

## Links

- [Github: kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
