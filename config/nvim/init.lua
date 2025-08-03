local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine the nvim-shared config path based on platform
local nvim_shared_path
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows: %USERPROFILE%\AppData\Local\nvim-shared
  nvim_shared_path = home .. sep .. "AppData" .. sep .. "Local" .. sep .. "nvim-shared"
else
  -- Unix: ~/.config/nvim-shared
  nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"
end

local use_shared = vim.fn.isdirectory(nvim_shared_path) == 1

local shared, platform

if use_shared then
  -- Prefer nvim-shared: add to runtimepath and try to require it
  vim.opt.runtimepath:append(nvim_shared_path)

  -- Debug print neovim's runtimepath
  -- print("rtp: ", vim.inspect(vim.opt.runtimepath:get()))
  -- Debug print neovim's package path
  -- print("pkg:", package.path)

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
  -- Fallback to local config
  require("config")
  platform = require("config.platform")
end

require("plugins.manager")

-- Set your active theme here
-- \ Managed by Themery plugin for this config
-- vim.cmd.colorscheme("catppuccin-mocha")
