-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Determine shared root (cross-platform)
local home = vim.fn.expand("~")
local sep = package.config:sub(1,1)
local nvim_shared_root

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Prefer LOCALAPPDATA if set, else fallback
  local localappdata = vim.env.LOCALAPPDATA or (home .. sep .. "AppData" .. sep .. "Local")
  nvim_shared_root = localappdata .. sep .. "nvim-shared"
else
  nvim_shared_root = home .. sep .. ".config" .. sep .. "nvim-shared"
end

-- Base specs
local specs = {
  { import = "plugins.lazy.packages" },
  { import = "themes" },
}

-- If nvim-shared exists, expose it and pull in the shared LSP bundle + helpers
if vim.fn.isdirectory(nvim_shared_root) == 1 then
  -- Prepend so it's found early
  vim.opt.rtp:prepend(nvim_shared_root)

  -- If your module layout lives under lua/, you can optionally adjust package.path,
  -- but prepending the root to rtp is usually sufficient for require("nvim-shared...")
  -- Example if you need it explicitly:
  -- local shared_lua = nvim_shared_root .. sep .. "lua"
  -- package.path = table.concat({
  --   shared_lua .. "/?.lua",
  --   shared_lua .. "/?/init.lua",
  --   package.path,
  -- }, ";")

  -- Acquire dynamic server list (with optional per-profile overrides)
  local ok_auto, auto_servers = pcall(require, "nvim-shared.lsp.auto_servers")
  local servers = {}
  if ok_auto and auto_servers then
    -- Example override for this profile; adjust or omit as needed:
    -- auto_servers.overrides.dotnet = {} -- disable dotnet servers here
    servers = auto_servers_
