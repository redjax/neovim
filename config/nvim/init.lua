local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine shared config root per platform
local nvim_shared_path
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows: use %LOCALAPPDATA%\nvim-shared if set, else fall back to ~/AppData/Local/nvim-shared
  local localappdata = vim.env.LOCALAPPDATA or (home .. sep .. "AppData" .. sep .. "Local")
  nvim_shared_path = localappdata .. sep .. "nvim-shared"
else
  -- Unix: ~/.config/nvim-shared
  nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"
end

local use_shared = vim.fn.isdirectory(nvim_shared_path) == 1

if use_shared then
  -- Prepend so shared modules are found early
  vim.opt.runtimepath:prepend(nvim_shared_path)

  -- Also add its lua subfolder to package.path for direct requires (if you still need it)
  local nvim_shared_lua = nvim_shared_path .. sep .. "lua"
  package.path = table.concat({
    nvim_shared_lua .. "/?.lua",
    nvim_shared_lua .. "/?/init.lua",
    package.path,
  }, ";")
end

local shared, platform
if use_shared then
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

require("plugins.manager")
