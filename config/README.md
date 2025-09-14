# Configuration Profiles <!-- omit in toc -->

My Neovim configurations. The default configuration in [`nvim`](./nvim/) is my main template. I make best efforts for a cross-platform configuration that will work on Linux and Windows.

## Table of Contents <!-- omit in toc -->

- [Requirements](#requirements)
- [Switching Configurations](#switching-configurations)
- [Configurations](#configurations)
  - [nvim (default)](#nvim-default)
  - [Kickstart](#kickstart)
    - [Kickstart requirements](#kickstart-requirements)
  - [No Plugins](#no-plugins)
  - [Work](#work)

## Requirements

Most configurations include a `README.md` that will detail any requirements for that configuration. If you use one of the install scripts ([Linux](../scripts/linux/install.sh)/[Windows](../scripts/windows/install-neovim-win.ps1)), and the accompanying LSP install script ([Linux](../scripts/linux/install-lsp-requirements.sh)/[Windows](../scripts/windows/install-lsp-requirements.ps1)), you should have all of the "common" dependencies any given profile might require.

In general, the following are required:

- `git`
- `make` / `CMake`
- `unzip`
- `gcc`
- `xclip` / [`win32yank`](https://github.com/equalsraf/win32yank)
- A [Nerd Font](https://www.nerdfonts.com/)
  - The setup scripts install `FiraCode` Nerd Fonts
- [`fzf`](https://github.com/junegunn/fzf)
- [`nodejs` / `npm`](https://nodejs.org/en)
  - The setup scripts install `nodejs-lts` with the [Node Version Manager (`nvm`)](https://github.com/nvm-sh/nvm) on Linux, and `nodejs-lts` via [`scoop`](https://scoop.sh) on Windows.
- [`python` / `pip`](https://www.python.org)

Some LSPs require [Go](https://golang.org) and/or [Rust](https://www.rust-lang.org) to be installed.

## Switching Configurations

> [!TIP]
> **TL/DR**: Use the `NVIM_APPNAME` environment variable to set which configuration profile is loaded, i.e. `NVIM_APPNAME="nvim-noplugins"`.

By default, Neovim will load the configuration at `~/.config/nvim` on Linux and `$env:LOCALAPPDATA\nvim` on Windows. My configuration places multiple configuration "profiles" at the config path, and you can control which profile is loaded using the `NVIM_APPNAME` environment variable.

Each configuration below has a table with the Linux and Windows environment variable you should set when you want to use a different profile. On Linux, you can use `export NVIM_APPNAME="nvim-profilename"` to temporarily set the Neovim profile for the current shell session, or add that line to your `~/.bashrc` to set it as the default. You can do the same on Windows, but using the `$env:NVIM_APPNAME="nvim-profilename"` environment variable.

## Configurations

### nvim (default)

| Config | Linux Env Var | Windows Env Var |
| ------ | ------------- | --------------- |
| [`nvim`](./nvim/) | None/unset | None/unset |

My 'default' configuration, custom-built by referencing configurations from all over the place.

### Kickstart

| Config | Linux Env Var | Windows Env Var |
| ------ | ------------- | --------------- |
| [`nvim-kickstart`](./nvim-kickstart/) | `$NVIM_APPNAME="nvim-kickstart` | `$env:NVIM_APPNAME="nvim-kickstart` |

Built from the [Kickstart.nvim repository](https://github.com/nvim-lua/kickstart.nvim).

#### Kickstart requirements

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

### No Plugins

| Config | Linux Env Var | Windows Env Var |
| ------ | ------------- | --------------- |
| [`nvim-noplugins`](./nvim-noplugins/) | `$NVIM_APPNAME="nvim-noplugins"` | `$env:NVIM_APPNAME="nvim-noplugins"` |

A configuration that loads the common configuration from the [shared profile](#shared), but does not have a plugin manager or load any plugins or themes. A "vanilla" configuration.

### Work

| Config | Linux Env Var | Windows Env Var |
| ------ | ------------- | --------------- |
| [`nvim-work`](./nvim-work/) | `$NVIM_APPNAME="nvim-work"` | `$env:NVIM_APPNAME="nvim-work"` |

My work profile, which I change & adapt to suit my environment at `$JOB`.
