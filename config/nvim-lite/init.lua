local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)

-- Determine shared root cross-platform
local nvim_shared_path
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  local localappdata = vim.env.LOCALAPPDATA or (home .. sep .. "AppData" .. sep .. "Local")
  nvim_shared_path = localappdata .. sep .. "nvim-shared"
else
  nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"
end

-- Require shared unconditionally; fail hard if absent
if vim.fn.isdirectory(nvim_shared_path) ~= 1 then
  error("nvim-shared not found at " .. nvim_shared_path)
end

-- Prepend shared root so require("nvim-shared") works
vim.opt.runtimepath:prepend(nvim_shared_path)

-- If your shared modules live under lua/, also ensure package.path covers them.
local shared_lua = nvim_shared_path .. sep .. "lua"
package.path = table.concat({
  shared_lua .. "/?.lua",
  shared_lua .. "/?/init.lua",
  package.path,
}, ";")

-- Load shared entrypoints
local ok, shared = pcall(require, "nvim-shared")
if not ok or not shared then
  error("Failed to load nvim-shared: " .. tostring(shared))
end
local platform = shared.platform
require("nvim-shared.config")

-- Then load plugin manager which will consume shared LSP etc.
require("manager")