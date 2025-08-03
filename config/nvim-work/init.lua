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

-- Set your active colorscheme (managed by Themery plugin)
vim.cmd.colorscheme("oxocarbon")
