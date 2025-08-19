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

🔗 [View all releases](https://github.com/redjax/neovim/releases)

*([Read more about how this repository creates releases](#releases))*

> [!WARNING]
> This documentation is out of date, I have changed the way I manage my Neovim configurations but have not fully updated the docs.
>
> I am working on a rewrite in the [`topic/docs-rewrite` branch](https://github.com/redjax/neovim/tree/topic/docs-rewrite).

## Table of Contents <!-- omit in toc -->

- [Documentation](#documentation)
- [Releases](#releases)
- [Instructions](#instructions)
- [Usage](#usage)
- [Updating](#updating)
- [Notes](#notes)
- [Links](#links)

## Documentation

📕 [Read the documentation](./docs)

## Releases

This repository releases .zip archives of the [neovim configurations in `config/`](./config). The [release pipeline](./.github/workflows/release.yml) is triggered manually, and creates the next patch version automatically (i.e. `v0.0.1` -> `v0.0.2`).

Each time a release is created, it will contain .zip archives of each configuration, named after the directory (i.e. `nvim-v0.0.1.zip` for the [default `nvim/` config](./config/nvim/)). When you extract the archive, a directory named `nvim/` will be created, containing the configuration you downloaded. You can move this file to the Neovim configuration path (`~/.config/nvim` on Linux, `%USERPROFILE%\AppData\Local\nvim` on Windows) to install the configuration. You can also extract the .zip archive directly to that path to extract & install in 1 step.

## Instructions

*[View installation documentation](./docs/INSTALL.md)*

- Clone repository with `git clone git@github.com:redjax/neovim` (or with HTTPS: `git clone https://github.com/redjax/neovim ./neovim`)
- Run the setup script for your platform:
  - [Linux](./docs/INSTALL.md#linux)
  - [Windows](./docs/INSTALL.md#windows)
- Run `nvim` to ensure everything installed correctly.
  - Read the [First Run documentation](./docs/USAGE.md#first-run) for more information on the errors you will probably see the first couple of times you run Neovim.
- (Optional) Change the [neovim configuration](./config/) to use by setting the `NVIM_APPNAME` var.
  - Read [Switching profiles](./docs/USAGE.md#switching-profiles) to learn how to use the `$NVIM_APPNAME` environment variable.

## Usage

*[View usage documentation](./docs/USAGE.md)*

## Updating

*[View Neovim app update documentation](./docs/USAGE.md#update-neovim-app)*

*[View Neovim configuration update documentation](./docs/USAGE.md#updating-neovim-configuration)*

*[View Neovim plugin update documentation](./docs/USAGE.md#updating-plugins)*

## Notes

*[View notes documentation](./docs/NOTES.md)*

## Links

*[View links documentation](./docs/LINKS.md)*
