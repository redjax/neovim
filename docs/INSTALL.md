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

Some configurations support the [`neovide` GUI environment](https://neovide.dev). There are install scripts for Neovide in the [Linux](./scripts/linux/install-neovide.sh) and [Windows](./scripts/windows/install-neovide.ps1) directories.

The Neovide configuration is defined in the [`nvim-shared` profile](./config/nvim-shared/lua/nvim-shared/neovide/). To import in one of your profiles, use something like this in the `init.lua`:

```lua
local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine shared config root per platform
local nvim_shared_path
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows: use %LOCALAPPDATA%\nvim-shared if set, else fall back to ~/AppData/Local/nvim-shared
  local localappdata = vim.env.LOCALAPPDATA or (home .. sep .. "AppData" .. sep .. "Local")
  nvim_shared_path = localappdata .. sep .. "nvim-shared"
else
  -- Unix: ~/.config/nvim-shared
  nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"
end

local use_shared = vim.fn.isdirectory(nvim_shared_path) == 1

if use_shared then
  -- Prepend so shared modules are found early
  vim.opt.runtimepath:prepend(nvim_shared_path)

  -- Also add its lua subfolder to package.path for direct requires (if you still need it)
  local nvim_shared_lua = nvim_shared_path .. sep .. "lua"
  package.path = table.concat({
    nvim_shared_lua .. "/?.lua",
    nvim_shared_lua .. "/?/init.lua",
    package.path,
  }, ";")
end

-- The rest of your configuration
-- \ then, load Neovide at the bottom

-- Load Neovide-specific config if running in Neovide
--   https://neovide.dev
if vim.g.neovide then
  local neovide_config_path = nvim_shared_path .. sep .. "neovide"
  if vim.fn.isdirectory(neovide_config_path) == 1 then
    -- Protected call to require neovide init.lua inside that directory
    local ok, _ = pcall(require, "neovide.init")
    if not ok then
      vim.notify("Failed to load Neovide config", vim.log.levels.WARN)
    end
  end
end
```
