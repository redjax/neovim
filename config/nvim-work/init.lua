local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine shared config path depending on platform
local nvim_shared_root
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows: use nvim-core path (adjust if needed)
  nvim_shared_root = home .. sep .. "AppData" .. sep .. "Local" .. sep .. "nvim-core"
else
  -- Unix-like: use nvim-shared path
  nvim_shared_root = home .. sep .. ".config" .. sep .. "nvim-shared"
end

-- Check if shared config directory exists
local use_shared = false
local stat = vim.loop.fs_stat(nvim_shared_root)
if stat and stat.type == "directory" then
  use_shared = true
end

local shared, platform

if use_shared then
  -- Append shared config to runtimepath (append preferred here to keep your runtimepath order)
  vim.opt.runtimepath:append(nvim_shared_root)

  local ok, mod = pcall(require, "nvim-shared")
  if ok and mod then
    shared = mod
    platform = shared.platform
    require("nvim-shared.config")
  else
    vim.notify("Failed to load nvim-shared module, falling back to local config.", vim.log.levels.WARN)
    require("config")
    platform = require("config.platform")
  end
else
  -- Fallback to local config
  require("config")
  platform = require("config.platform")
end

-- Load plugin manager
require("manager")

-- Set your active colorscheme (managed by Themery)
vim.cmd.colorscheme("oxocarbon")
