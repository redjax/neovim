local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine the nvim-core config path based on platform
local nvim_core_path
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows: %USERPROFILE%\AppData\Local\nvim-core
  nvim_core_path = home .. sep .. "AppData" .. sep .. "Local" .. sep .. "nvim-core"
else
  -- Unix: ~/.config/nvim-core
  nvim_core_path = home .. sep .. ".config" .. sep .. "nvim-core"
end

local use_core = vim.fn.isdirectory(nvim_core_path) == 1

local core, platform

if use_core then
  -- Prefer nvim-core: add to runtimepath and try to require it
  vim.opt.runtimepath:append(nvim_core_path)
  local ok, mod = pcall(require, "nvim-core")
  if ok and mod then
    core = mod
    platform = core.platform
    require("nvim-core.config")
  else
    vim.notify("Failed to load nvim-core, falling back to local config.", vim.log.levels.WARN)
    require("config")
    platform = require("config.platform")
  end
else
  -- Fallback to local config
  require("config")
  platform = require("config.platform")
end

require("plugins.manager")

-- Set your active theme here
-- \ Managed by Themery plugin for this config
-- vim.cmd.colorscheme("catppuccin-mocha")
