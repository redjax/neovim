# Neovim LSP

This is a special profile, where Language Server Protocol (LSP) servers are defined & initialized. This profile is not meant to be used directly (i.e. with `NVIM_APPNAME=nvim-lsp`). Instead, it should be imported into other profiles.

## Usage

My configurations all have a `manager.lua` in the `plugins/` directory. This file handles sourcing my plugins, and acts as a sort of `init.lua` file for plugins.

To add an import for `nvim-lsp`, I dynamically create a `specs` object to pass into `require("lazy").setup({ spec = specs })`.

Here is an example `manager.lua`:

```lua
-- Look for lazy in the nvim data directory
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- If lazy is not installed, install it
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
-- Add lazy to Neovim's path
vim.opt.rtp:prepend(lazypath)

-- Set $HOME dir (cross platform)
local home = vim.fn.expand("~")
-- Detect path separator (/ or \)
local sep = package.config:sub(1,1)
-- Build path to shared nvim-lsp language server config
local nvim_lsp_path = home .. sep .. ".config" .. sep .. "nvim-lsp"

-- Build specs object
local specs = {
  -- Assumes your config has a lua/plugins dir,
  -- with a lazy/packages subdirectory where plugins are defined
  { import = "plugins.lazy.packages" },
  -- Import themes from config's lua/themes
  { import = "themes" },
}

-- Check if nvim-lsp config path exists
if vim.loop.fs_stat(nvim_lsp_path) and vim.loop.fs_stat(nvim_lsp_path).type == "directory" then
  -- Add nvim-lsp config to Neovim path
  vim.opt.runtimepath:append(nvim_lsp_path)
  -- Add nvim-lsp config to specs
  table.insert(specs, { import = "nvim-lsp" })
end

-- Setup lazy plugin manager
require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
```
