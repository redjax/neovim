# Installation <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Requirements](#requirements)
  - [Neovim version](#neovim-version)
  - [Dependencies](#dependencies)
- [Linux](#linux)
- [Windows](#windows)
- [Neovide](#neovide)

## Requirements

### Neovim version

Minimum: `v0.11.0`

*check with `nvim --version`*

### Dependencies

> [!WARNING]
> The Linux install script(s) do not support LXC container environments or ARM CPUs.
> 
> I have access to both of these environments and will develop the configuration for those platforms,
but until this message is removed, LXC containers and ARM CPUs are not supported.

If you install `neovim` using one of the [install/setup scripts](./scripts/), the dependencies for my `neovim` configurations will be installed automatically.

Each [neovim configuration/profile](./config/) should have a `README.md` detailing any specific requirements. Some profiles, like the [`nvim-noplugins` profile](./config/nvim-noplugins/), do not have any dependencies, just configurations for stock neovim.

## Linux

The [Linux setup script](./scripts/linux/install.sh) installs & configures `neovim` and any dependencies needed to build/configure/run the program. The script also creates a symlink of each Neovim configuration in the [`config/` directory](./config/) to the `~/.config/{neovim-config-name}` path on the host.

Run `./scripts/linux/install.sh` to install `neovim` and its dependencies.

## Windows

The [Windows setup script](./scripts/windows/install-neovim-win.ps1) installs the [`scoop` package manager](https://scoop.sh), then installs all `neovim` requirements (including `nodejs-lts`) with it. `neovim` itself is installed with `scoop` using this script.

I chose `scoop` over other options like `winget` and `chocolatey` because every dependency I need is there, the setup is simple, and it keeps everything contained to a path instead of throwing shit all over the OS's `$PATH`.

- Run [`./scripts/windows/install-neovim-win.ps1`](./scripts/windows/install-neovim-win.ps1)
  - **NOTE**: Windows requires Administrator priviliges to create path junctions. If you use the [Windows setup script](./scripts/windows/install-neovim-win.ps1), the junction will call the `Run-AsAdmin` command if the script is not running in an elevated session; you may see a UAC prompt, have to type a password, or you might see a blue Powershell window flash on the screen for a moment.

## Neovide

Some configurations support the [`neovide` GUI environment](https://neovide.dev). For example, [here is the `nvim-work` profile's `neovide/` config dir](../config/nvim-work/lua/neovide/). The [`nvim-work` profile's `init.lua`](../config/nvim-work/init.lua) can then import this conditionally with:

```lua
-- Load Neovide-specific config if running in Neovide
--   https://neovide.dev
if vim.g.neovide then
  -- Protected call to require neovide init.lua
  local ok, _ = pcall(require, "neovide.init")
  if not ok then
    vim.notify("Failed to load Neovide config", vim.log.levels.WARN)
  end
end

```
