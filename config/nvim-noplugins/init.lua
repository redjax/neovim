local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine the nvim-shared config path based on platform
local nvim_shared_path
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  nvim_shared_path = home .. sep .. "AppData" .. sep .. "Local" .. sep .. "nvim-shared"
else
  nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"
end

local use_core = vim.fn.isdirectory(nvim_shared_path) == 1

local core, platform

if use_core then
  vim.opt.runtimepath:append(nvim_shared_path)
  local ok, mod = pcall(require, "nvim-shared")
  if ok and mod then
    core = mod
    platform = core.platform
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
