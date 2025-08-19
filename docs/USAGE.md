# Usage <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [First Run](#first-run)
- [Updating Plugins](#updating-plugins)
- [Updating Neovim Configuration](#updating-neovim-configuration)
- [Update Neovim App](#update-neovim-app)
  - [Update on Linux](#update-on-linux)
  - [Update on Windows](#update-on-windows)
- [Switching profiles](#switching-profiles)
  - [Temporarily switch profiles](#temporarily-switch-profiles)
    - [Linux](#linux)
    - [Windows](#windows)
  - [Permanently set/change default profile](#permanently-setchange-default-profile)
    - [Linux](#linux-1)
    - [Windows](#windows-1)

## First Run

After installing Neovim and my configurations, Lazy vim might act weird due to how LSPs are loaded. You might see a lot of errors the first of times you open Neovim, as Lazy and Mason do their setup/configuration.

The errors are ok, and should stop after the 2nd or 3rd launch of Neovim.

## Updating Plugins

I use the [Lazy package manager](https://www.lazyvim.org) to handle installing & configuring my plugins. Besides the [`nvim-noplugins` config](../config/nvim-noplugins/), each profile uses Lazy and [Mason](https://github.com/mason-org/mason.nvim) to automatically setup LSPs and plugins.

You will occasionally see a message about plugins that need to be updated. You can update the plugins using either `:Lazy update`, or `:Lazy` and then press `U`.

## Updating Neovim Configuration

To pull new changes, `cd` to wherever you cloned this repository and run a `git fetch ; git pull`. Then, relaunch Neovim.

> [!TIP]
> After pulling changes from the remote, you may see errors the first time you launch Neovim.
> I recommend running `:Lazy sync`, then hit `X` to run a clean. Then, close and re-open Neovim and let
> Lazy reconfigure itself.

## Update Neovim App

### Update on Linux

Run `sudo rm $(which nvim)`, then re-run the [Linux install script at `./scripts/linux/install.sh `](./scripts/linux/install.sh). This will re-install the latest version of Neovim from source.

### Update on Windows

Update Neovim using whichever installer you used.

- Github release: [download & install latest release](https://github.com/neovim/neovim/releases/latest)
- Winget: Run `winget update Neovim.Neovim`
- Scoop: Run `scoop update neovim`
- Chocolatey: Run `choco upgrade neovim`

## Switching profiles

The install scripts create symbolic links to each configuration in the [`config/` directory](./config). By default, running `nvim` will open the configuration at `~/.config/nvim` (or `$env:LOCALAPPDATA\nvim` on Windows).

You can have Neovim open a different configuration by setting the `NVIM_APPNAME` environment variable.

### Temporarily switch profiles

#### Linux

Prepend your `nvim` command with `NVIM_APPNAME=`:

```bash
NVIM_APPNAME=nvim-configname nvim
```

Use an existing configuration name, i.e. [`nvim-kickstart`](./config/nvim-kickstart/) or [`nvim-noplugins`](./config/nvim-noplugins/).

#### Windows

In a Powershell prompt, run:

```powershell
$env:NVIM_APPNAME=nvim-configname; nvim
```

Use an existing configuration name, i.e. [`nvim-kickstart`](./config/nvim-kickstart/) or [`nvim-noplugins`](./config/nvim-noplugins/).

You may see an error about HOME not being set:

```shell
Error detected while processing C:\Users\$USERNAME\AppData\Local\nvim-noplugins\init.lua:
HOME not set! Undo directory not configured.
```

If you see this, you must also set a value for `$env:HOME`:

```shell

$env:HOME=$env:USERPROFILE; $NVIM_APPNAME="nvim-noplugins"; nvim
```

### Permanently set/change default profile

If you export the `NVIM_APPNAME` environment variable globally, you can set the configuration Neovim will use whenever you run `nvim`. You can still [temporarily override the profile](#temporarily-switch-profiles).

#### Linux

Export the `NVIM_APPNAME` environment variable, i.e. by putting the following in your `~/.bashrc`:

```bash
NVIM_APPNAME="nvim-configname"
```

Use an existing configuration name, i.e. [`nvim-kickstart`](./config/nvim-kickstart/) or [`nvim-noplugins`](./config/nvim-noplugins/).

#### Windows

On Windows, you can set this environment variable by hitting the Start button, searching for "environment variables," and opening the option to edit the user's environment variables. Then, create a new variable called `NVIM_APPNAME`, and set the value to the configuration you want to use, i.e. `nvim-noplugins`.

You can also do this with an elevated Powershell prompt using `setx`:

```powershell
setx NVIM_APPNAME "nvim-configname"
```

Use an existing configuration name, i.e. [`nvim-kickstart`](./config/nvim-kickstart/) or [`nvim-noplugins`](./config/nvim-noplugins/).

You may see an error about HOME not being set:

```shell
Error detected while processing C:\Users\$USERNAME\AppData\Local\nvim-noplugins\init.lua:
HOME not set! Undo directory not configured.
```

If you see this, you must also set a value for `$env:HOME`:

```shell

setx HOME "$env:USERPROFILE"; setx NVIM_APPNAME "nvim-noplugins"
```
