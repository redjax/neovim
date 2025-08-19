# Configuration Profiles <!-- omit in toc -->

My Neovim configurations. The default configuration in [`nvim`](./nvim/) is my main template. I make best efforts for a cross-platform configuration that will work on Linux and Windows.

## Table of Contents <!-- omit in toc -->

- [Requirements](#requirements)
- [Switching Configurations](#switching-configurations)
- [Configurations](#configurations)
  - [nvim (default)](#nvim-default)
  - [Shared](#shared)
    - [Example import](#example-import)
  - [Kickstart](#kickstart)
    - [Kickstart requirements](#kickstart-requirements)
  - [Lite](#lite)
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

### Shared

| Config | Linux Env Var | Windows Env Var | 
| ------ | ------------- | --------------- |
| [`nvim-shared`](./nvim-shared/) | None/unset | None/unset |

> [!WARNING]
> This configuration is not meant to be loaded directly.
> Other profiles load configurations like keybinds from this module.

I keep common/shared code in the `nvim-shared` profile. Other profiles can import configurations from this profile, like keymaps, UI options, etc.

There are also some shared plugin configurations, like the [shared LSP config](./nvim-shared/lua/nvim-shared/lsp/).

#### Example import

In this example, the [`nvim-shared.config` module](./nvim-shared/lua/nvim-shared/config/) will be imported into `init.lua`.

Get the path to `$HOME`/`~` and the OS path separator (`/` or `\`).

```lua
local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)
```

Set the path to the `nvim-shared` config directory (`~/.config/nvim/nvim-shared` on Linux/Mac, and `%LOCALAPPDATA%\nvim-shared` on Windows).

```lua
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

-- If nvim-shared profile was found, use it in this configuration
local use_shared = vim.fn.isdirectory(nvim_shared_path) == 1
```

Add shared config to the `vim.opt.runtimepath` and load the configuration from the `lua` directory.

```lua
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
```

Import `nvim-shared.config`, which sets defaults for keybinds, UI, terminal, & more. These are generally settings I want all configurations to have in common, or to select from a standardized configuration.

```lua
local shared, platform
if use_shared then
  local ok, mod = pcall(require, "nvim-shared")
  if ok and mod then
    shared = mod
    platform = shared.platform
    require("nvim-shared.config")
  else
    vim.notify("Failed to load nvim-shared, falling back to local config.", vim.log.levels.WARN)
    require("config")
    platform = require("config.platform")
  end
else
  require("config")
  platform = require("config.platform")
end
```

Full version:

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

-- If nvim-shared profile was found, use it in this configuration
local use_shared = vim.fn.isdirectory(nvim_shared_path) == 1

local shared, platform
if use_shared then
  local ok, mod = pcall(require, "nvim-shared")
  if ok and mod then
    shared = mod
    platform = shared.platform
    require("nvim-shared.config")
  else
    vim.notify("Failed to load nvim-shared, falling back to local config.", vim.log.levels.WARN)
    require("config")
    platform = require("config.platform")
  end
else
  require("config")
  platform = require("config.platform")
end

-- Any other customizations/imports here ...
```

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

### Lite

| Config | Linux Env Var | Windows Env Var |
| ------ | ------------- | --------------- |
| [`nvim-lite`](./nvim-lite/) | `$NVIM_APPNAME="nvim-lite"` | `$env:NVIM_APPNAME="nvim-lite"` |

My "lightweight". It uses plugins and themes, but I try not to overload with plugins, and only keep a couple of themes handy.

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
