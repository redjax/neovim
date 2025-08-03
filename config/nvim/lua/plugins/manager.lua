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

-- Shared path setup
local home = vim.fn.expand("~")
local sep = package.config:sub(1,1)
local nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"

-- Plugin specs
local specs = {
  { import = "plugins.lazy.packages" },
  { import = "themes" },
}

-- If nvim-shared exists, make it available early and add its LSP bundle + related pieces
if vim.fn.isdirectory(nvim_shared_path) == 1 then
  vim.opt.runtimepath:prepend(nvim_shared_path)

  -- (Optional) adjust package.path if your layout requires explicit lua subdir exposure
  local shared_lua = nvim_shared_path .. sep .. "lua"
  package.path = table.concat({
    shared_lua .. "/?.lua",
    shared_lua .. "/?/init.lua",
    package.path,
  }, ";")

  -- Acquire dynamic servers with overrides if needed
  local ok_auto, auto_servers = pcall(require, "nvim-shared.lsp.auto_servers")
  local servers = {}
  if ok_auto and auto_servers then
    -- Example override; adjust per-profile externally if desired
    auto_servers.overrides.dotnet = {} -- disable dotnet in this profile
    servers = auto_servers.get()
  else
    vim.notify("Failed to load auto_servers: " .. tostring(auto_servers), vim.log.levels.WARN)
  end

  -- Shared LSP pieces
  table.insert(specs, { import = "nvim-shared.lsp.plugins.mason" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.cmp" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.signature" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.none_ls" })
  table.insert(specs, { import = "nvim-shared.lsp.bundle", opts = { ensure_installed = servers } })
  table.insert(specs, { import = "nvim-shared.lsp.dap" })
end

-- Setup lazy.nvim
require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
