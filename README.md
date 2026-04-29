# Neovim Configuration <!-- omit in toc -->

<!-- Repo image -->
<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset=".static/img/neovim-banner.png">
    <img src=".static/img/neovim-banner.png" height="200">
  </picture>
</p>

<p align="center">
  <img alt="GitHub Created At" src="https://img.shields.io/github/created-at/redjax/neovim">
  <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/redjax/neovim">
  <img alt="GitHub Commits this Year" src="https://img.shields.io/github/commit-activity/y/redjax/neovim">
  <img alt="Github Repo Size" src="https://img.shields.io/github/repo-size/redjax/neovim">
</p>

My `neovim` configurations as a git repository.

> [!TIP]
> I am working porting my [main config](./config/nvim) to Neovim 0.12.0 compatible config, replacing the Lazy package manager with
> the new built-in [`vim.pack`](https://neovim.io/doc/user/pack/).
>
> This development is happening on the [`feat/nvim-12-profile` branch](https://github.com/redjax/neovim/tree/feat/nvim-12-profile)

> - 🔗 [View all releases](https://github.com/redjax/neovim/releases)
>   - [Read more about how this repository creates releases](#releases)
> - 📕 [Read the documentation](./docs/README.md)
> [!TIP]
> I am working porting my [main config](./config/nvim) to Neovim 0.12.0 compatible config, replacing the Lazy package manager with
> the new built-in [`vim.pack`](https://neovim.io/doc/user/pack/).
>
> This development is happening on the [`feat/nvim-12-profile` branch](https://github.com/redjax/neovim/tree/feat/nvim-12-profile)

> - 🔗 [View all releases](https://github.com/redjax/neovim/releases)
>   - [Read more about how this repository creates releases](#releases)
> - 📕 [Read the documentation](./docs/README.md)

## Table of Contents <!-- omit in toc -->

- [Releases](#releases)
- [Instructions](#instructions)
- [Usage](#usage)
- [Plugins](#plugins)
- [Updating](#updating)
- [Notes](#notes)
- [Links](#links)

## Releases

This repository releases .zip archives of the [neovim configurations in `config/`](./config). The [release pipeline](./.github/workflows/release.yml) is triggered manually, and creates the next patch version automatically (i.e. `v0.0.1` -> `v0.0.2`).

Each time a release is created, it will contain .zip archives of each configuration, named after the directory (i.e. `nvim-v0.0.1.zip` for the [default `nvim/` config](./config/nvim/)). When you extract the archive, a directory named `nvim/` will be created, containing the configuration you downloaded. You can move this file to the Neovim configuration path (`~/.config/nvim` on Linux, `%USERPROFILE%\AppData\Local\nvim` on Windows) to install the configuration. You can also extract the .zip archive directly to that path to extract & install in 1 step.

## Instructions

_[View installation documentation](./docs/INSTALL.md)_
_[View installation documentation](./docs/INSTALL.md)_

- Clone repository with `git clone git@github.com:redjax/neovim` (or with HTTPS: `git clone https://github.com/redjax/neovim ./neovim`)
- Run the setup script for your platform:
  - [Linux](./docs/INSTALL.md#linux)
  - [Windows](./docs/INSTALL.md#windows)
- Run `nvim` to ensure everything installed correctly.
  - Read the [First Run documentation](./docs/USAGE.md#first-run) for more information on the errors you will probably see the first couple of times you run Neovim.
- (Optional) Change the [neovim configuration](./config/) to use by setting the `NVIM_APPNAME` var.
  - Read [Switching profiles](./docs/USAGE.md#switching-profiles) to learn how to use the `$NVIM_APPNAME` environment variable.

> [!NOTE]
> You can also run `nvim --headless '+Lazy! sync' '+Lazy! clean' +qa` to automatically run a Sync and Clean operation, then quit Neovim.
> The `--headless` flag will prevent the main `neovim` window from opening, instead showing you the output as log lines.
>
> There is a script for [Windows](./scripts/windows/lazy-sync.ps1) and [Linux](./scripts/linux/lazy-sync.sh) that will run this operation
> for the [`nvim`](./config/nvim/) and [`nvim-work`](./config/nvim-work/) profiles, or you can pass 1 or more `-p/--profile <profile-name>` to customize which lockfiles are updated.

## Usage

_[View usage documentation](./docs/USAGE.md)_

## Plugins

_[View plugin documentation](./docs/PLUGINS)_

## Updating

_[View Neovim app update documentation](./docs/USAGE.md#update-neovim-app)_
_[View Neovim app update documentation](./docs/USAGE.md#update-neovim-app)_

_[View Neovim configuration update documentation](./docs/USAGE.md#updating-neovim-configuration)_
_[View Neovim configuration update documentation](./docs/USAGE.md#updating-neovim-configuration)_

_[View Neovim plugin update documentation](./docs/USAGE.md#updating-plugins)_
_[View Neovim plugin update documentation](./docs/USAGE.md#updating-plugins)_

## Notes

_[View notes documentation](./docs/NOTES.md)_
_[View notes documentation](./docs/NOTES.md)_

## Links

_[View links documentation](./docs/LINKS.md)_
_[View links documentation](./docs/LINKS.md)_
