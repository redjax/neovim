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
  - [Docker](#docker)
    - [Build the container](#build-the-container)
    - [Run the container](#run-the-container)
- [Notes](#notes)
- [Links](#links)

## Requirements

```warning

WARNING
-------

The Linux install script(s) do not support LXC container environments or ARM CPUs.

I have access to both of these environments and will develop the configuration for those platforms,
but until this message is removed, LXC containers and ARM CPUs are not supported.
```

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

The [Linux setup script](./scripts/linux/install.sh) installs & configures `neovim` and any dependencies needed to build/configure/run the program. The script also creates a symlink of the [`config/nvim`](./config/nvim) profile at `~/.config/nvim`.

Run `./scripts/linux/install.sh` to install `neovim` and its dependencies.

### Windows

The [Windows setup script](./scripts/windows/install-neovim-win.ps1) installs the [`scoop` package manager](https://scoop.sh), then installs all `neovim` requirements (including `nodejs-lts`) with it. `neovim` itself is installed with `scoop` using this script.

I chose `scoop` over other options like `winget` and `chocolatey` because every dependency I need is there, the setup is simple, and it keeps everything contained to a path instead of throwing shit all over the OS's `$PATH`.

- Run [`./scripts/windows/install-neovim-win.ps1`](./scripts/windows/install-neovim-win.ps1)
  - **NOTE**: Windows requires Administrator priviliges to create path junctions. If you use the [Windows setup script](./scripts/windows/install-neovim-win.ps1), the junction will call the `Run-AsAdmin` command if the script is not running in an elevated session; you may see a UAC prompt, have to type a password, or you might see a blue Powershell window flash on the screen for a moment.

### Docker

This repository includes Docker images for building Neovim with my custom config in a container environment. The Dockerfiles can be found in the [containers/](./containers/) path. For example, [`deb.Dockerfile`](./containers/deb.Dockerfile) builds `neovim` on a Debian base and installs the configuration for Debian.

The containers set up an environment to run [`install.sh`](./scripts/linux/install.sh), and can be used to test my `neovim` setup across multiple platforms.

#### Build the container

To build the container, run the [`build-deb-img.sh`](./scripts/docker/build-deb-img.sh) (for Debian) or [`build-rpm-img.sh`](./scripts/docker/build-rpm-img.sh) (for Fedora) script.

You can also manually build the command (note: add `--progress=plain` to the end of the docker build command to see all build output):

```shell
## Enable CONTAINER_ENV and set a build path for Neovim before running container
#  This example builds the deb.Dockerfile Debian container environment
CONTAINER_ENV=1 NEOVIM_MAKE_BUILD_DIR="/tmp/build" docker build -f ./containers/deb.Dockerfile -t neovim-buildtest .
```
#### Run the container

After building the Docker container, you can run it with:

```shell
docker exec --rm -it nvim-buildtest /bin/bash
```

Once you're in the container, open neovim with `nvim`. The `Lazy` installer should kick off and build the configuration. After this first execution, each subsequent run will launch immediately, until the container is rebuilt.

## Notes

- View available colorschemes by opening neovim and running `:Telescope colorscheme`
- Press `<Space>` to open an interactive menu
- Run `:Lazy` to open the package manager

## Links

- [Github: kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [Github: lazy.nvim](https://github.com/folke/lazy.nvim)
- [LazyVim Docs](https://lazy.folke.io)
