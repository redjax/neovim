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
  -- Prepend so shared modules are resolved early
  vim.opt.rtp:prepend(nvim_shared_root)

  -- Acquire dynamic server list (with optional per-profile overrides)
  local ok_auto, auto_servers = pcall(require, "nvim-shared.lsp.auto_servers")
  local servers = {}
  if ok_auto and auto_servers then
    -- Example overrides for this profile (customize or remove as needed)
    -- auto_servers.overrides.dotnet = {} -- disable dotnet if desired
    -- auto_servers.overrides.npm = { "bashls", "jsonls" } -- tailor npm LSPs
    servers = auto_servers.get()
  else
    vim.notify("Failed to load nvim-shared.lsp.auto_servers: " .. tostring(auto_servers), vim.log.levels.WARN)
  end

  -- Add shared LSP-related specs
  table.insert(specs, { import = "nvim-shared.lsp.plugins.mason" })
  -- table.insert(specs, { import = "nvim-shared.lsp.plugins.cmp" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.signature" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.none_ls" })
  table.insert(specs, { import = "nvim-shared.lsp.bundle", opts = { ensure_installed = servers } })
  table.insert(specs, { import = "nvim-shared.lsp.dap" })
end

-- Finalize lazy.nvim setup
require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
