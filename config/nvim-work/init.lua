local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Use nvim-shared on all platforms for consistency
local nvim_shared_root = nil

-- On Windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  nvim_shared_root = home .. sep .. "AppData" .. sep .. "Local" .. sep .. "nvim-shared"
else
  -- Unix-like
  nvim_shared_root = home .. sep .. ".config" .. sep .. "nvim-shared"
end

-- Check if shared config directory exists
local stat = vim.loop.fs_stat(nvim_shared_root)
if not (stat and stat.type == "directory") then
  error(("Shared config folder not found at '%s'. Please ensure the directory exists."):format(nvim_shared_root))
end

-- Append shared config to runtimepath (append to keep order)
vim.opt.runtimepath:append(nvim_shared_root)

-- Require shared config module, error if it fails
local ok, shared = pcall(require, "nvim-shared")
if not ok or not shared then
  error("Failed to load shared config module 'nvim-shared'.")
end

local platform = shared.platform

-- Require shared config setup
require("nvim-shared.config")

-- Load plugin manager
require("manager")

-- Set your active colorscheme
vim.cmd.colorscheme("one_monokai")

-- Load Neovide-specific config if running in Neovide
--   https://neovide.dev
if vim.g.neovide then
  local neovide_config_path = nvim_shared_root .. sep .. "neovide"
  if vim.fn.isdirectory(neovide_config_path) == 1 then
    -- Protected call to require neovide init.lua inside that directory
    local ok, _ = pcall(require, "neovide.init")
    if not ok then
      vim.notify("Failed to load Neovide config", vim.log.levels.WARN)
    end
  end
end
