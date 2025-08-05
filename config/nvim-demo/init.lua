local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine shared root (cross-platform)
local nvim_shared_root
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  nvim_shared_root = vim.env.LOCALAPPDATA and (vim.env.LOCALAPPDATA .. sep .. "nvim-shared")
    or (home .. sep .. "AppData" .. sep .. "Local" .. sep .. "nvim-shared")
else
  nvim_shared_root = home .. sep .. ".config" .. sep .. "nvim-shared"
end

local use_shared = vim.fn.isdirectory(nvim_shared_root) == 1
local shared, platform

if use_shared then
  vim.opt.runtimepath:prepend(nvim_shared_root) -- make shared modules resolvable early

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

-- Now initialize plugins (this will bootstrap lazy.nvim etc.)
require("plugins.manager")

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