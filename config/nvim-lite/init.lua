local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)
local nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"

local use_shared = vim.fn.isdirectory(nvim_shared_path) == 1

if use_shared then
  vim.opt.runtimepath:prepend(nvim_shared_path)

  -- Add lua folder for Lua require to work
  local nvim_shared_lua = nvim_shared_path .. sep .. "lua"
  package.path = table.concat({
    nvim_shared_lua .. "/?.lua",
    nvim_shared_lua .. "/?/init.lua",
    package.path,
  }, ";")

  -- print("Prepended nvim-shared path and updated package.path")
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

require("manager")


-- Set your active theme here
-- \ Managed by Themery plugin for this config
vim.cmd.colorscheme("oxocarbon")
