local uv = vim.loop

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Helpers to discover shared root
local home = vim.fn.expand("~")
local sep = package.config:sub(1,1)
local nvim_shared_root
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  local localappdata = vim.env.LOCALAPPDATA or (home .. sep .. "AppData" .. sep .. "Local")
  nvim_shared_root = localappdata .. sep .. "nvim-shared"
else
  nvim_shared_root = home .. sep .. ".config" .. sep .. "nvim-shared"
end

-- Build base spec list: local first so it can override shared definitions
local specs = {
  { import = "plugins.local" }, -- your profile-specific plugin definitions
}

-- Optionally include shared bundles or store items:
-- Example: include a shared bundle named "lazydev"
table.insert(specs, { import = "nvim-shared.plugins.lazy.bundles.lazydev" })

-- If shared exists, add its LSP + other helpers
if vim.fn.isdirectory(nvim_shared_root) == 1 then
  vim.opt.runtimepath:prepend(nvim_shared_root)

  -- Acquire dynamic server list if available
  local ok_auto, auto_servers = pcall(require, "nvim-shared.lsp.auto_servers")
  local servers = {}
  if ok_auto and auto_servers then
    -- you can adjust per-profile overrides here if desired:
    -- auto_servers.overrides.dotnet = {}
    servers = auto_servers.get()
  else
    vim.notify("Failed to load nvim-shared.lsp.auto_servers: " .. tostring(auto_servers), vim.log.levels.WARN)
  end

  -- Shared LSP-related specs (after local so local could shadow if defined)
  table.insert(specs, { import = "nvim-shared.lsp.plugins.mason" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.cmp" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.signature" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.none_ls" })
  table.insert(specs, { import = "nvim-shared.lsp.bundle", opts = { ensure_installed = servers } })
  table.insert(specs, { import = "nvim-shared.lsp.dap" })
end

-- Finally, setup lazy.nvim
require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
