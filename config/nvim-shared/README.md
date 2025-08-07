# Shared Neovim Configurations <!-- omit in toc -->

This directory contains all shared Neovim configurations, which other Neovim profiles can import. For example, a profile can import my standard keybinds by importing `nvim-shared.config.keymap`.

## Table of Contents <!-- omit in toc -->

- [Shared Config](#shared-config)
  - [Keymap](#keymap)
  - [Platform](#platform)
  - [Options](#options)
- [Shared Language Server Protocol (LSP) \& Debug Adapter (DAP) configs](#shared-language-server-protocol-lsp--debug-adapter-dap-configs)
  - [Importing LSPs](#importing-lsps)
- [Shared Plugins](#shared-plugins)

## Shared Config

*[`nvim-shared.config`](./lua/nvim-shared/config/)*

The `config` module sets defaults for built-in Neovim functionality, like keymaps, UI/terminal/window settings, clipboard, etc.

Plugins manager their own configs/keybinds using the [Lazy](https://github.com/folke/lazy.nvim) package manager.

### Keymap

*[`nvim-shared.config.keymap.lua`](./lua/nvim-shared/config/keymap.lua)*

My default Neovim keybind overrides. These are NOT keybinds for plugins, this is just for remapping functionality built into Neovim. Plugin files define their own keybinds.

### Platform

*[`nvim-shared.config.platform`](./lua/nvim-shared/config/platform.lua)*

Detects the platform Neovim is running on to handle dynamic configuration in profiles.

### Options

*[`nvim-shared.config.options`](./lua/nvim-shared/config/options/)*

Configurations in the `options` path set defaults for the Neovim standard release. They include defining clipboard behavior, code folding, indentation, search options, terminal and window settings, etc.

## Shared Language Server Protocol (LSP) & Debug Adapter (DAP) configs

*[`nvim-shared.lsp`](./lua/nvim-shared/lsp/)*

LSP & DAP provider configurations, managed with Lazy and the [`mason.nvim` plugin](https://github.com/mason-org/mason.nvim). The [Mason config](./lua/nvim-shared/lsp/lsp_plugins/mason.lua) handles installing LSP and DAP providers based on available tooling in the environment.

The [LSP config](./lua/nvim-shared/lsp/lsp_plugins/lsp.lua), installed by Lazy, defines providers for languages I use often, like Bash, Powershell, Python, Go, etc. If a language runtime is available in the environment, Mason will install the LSP for that language.

Completions & suggestions are also handled in this configuration.

### Importing LSPs

The [`lsp` configuration](./lua/nvim-shared/lsp/) is not loaded with `nvim-shared`. This is because a) it's heavy and adds a lot of time to initial setup/installation, and b) I do not necessarily want LSP/DAP functionality in every config.

Instead, I leave it up to individual configurations to import them. For example, the [default `nvim` configuration's `plugins.manager.lua`](../nvim/lua/plugins/manager.lua) checks for the existence of `~/.config/nvim-shared` (or `$env:LOCALAPPDATA\nvim-shared` on Windows) and imports `nvim-shared.lsp`:

```lua
## this is not the full manager.lua, just a snippet showing LSP import

-- Set $HOME dir (cross platform)
local home = vim.fn.expand("~")
-- Detect path separator (/ or \)
local sep = package.config:sub(1,1)
-- Build path to shared nvim-shared language server config
local nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"

-- Build specs object for lazy init
local specs = {
  { import = "plugins.lazy.packages" },
  { import = "themes" },
}

-- Check if nvim-shared config path exists & add to specs for lazy
if vim.loop.fs_stat(nvim_shared_path) and vim.loop.fs_stat(nvim_shared_path).type == "directory" then
  vim.opt.runtimepath:append(nvim_shared_path)
  table.insert(specs, { import = "nvim-shared.lsp" })
end

-- Setup lazy plugin manager
require("lazy").setup({
  spec = specs, -- if ~/.config/nvim-shared/lua/nvim-shared/lsp exists, it will be imported
  change_detection = { notify = false },
  checker = { enabled = true },
})

```

## Shared Plugins

...
