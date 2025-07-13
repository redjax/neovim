-- Check if ~/.config/nvim-core exists
local nvim_core_path = vim.fn.expand("~/.config/nvim-core")
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
