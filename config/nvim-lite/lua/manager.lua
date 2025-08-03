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

-- Set $HOME dir (cross platform)
local home = vim.fn.expand("~")
-- Detect path separator (/ or \)
local sep = package.config:sub(1,1)
local nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"

-- Build specs object for lazy init
local specs = {
  { import = "plugins" },
  { import = "themes" },
}

-- Check if nvim-shared config path exists
if vim.loop.fs_stat(nvim_shared_path) and vim.loop.fs_stat(nvim_shared_path).type == "directory" then
  vim.opt.runtimepath:append(nvim_shared_path)

  -- Import auto_servers from shared LSP config
  local auto_servers = require("nvim-shared.lsp.auto_servers")

  -- Override npm servers for this profile
  auto_servers.overrides.npm = {
    "ansiblels",
    "bashls",
    "docker_compose_language_service",
    "dockerls",
    "gh_actions_ls",
    "html",
    "jsonls",
    "pyright",
    "sqlls",
    "yamlls",
  }
  auto_servers.overrides.dotnet = {}

  -- Get list (will include base + dotnet/go/npm servers available + overrides)
  local servers = auto_servers.get()

  -- Add extras from nvim-shared
  table.insert(specs, { import = "nvim-shared.lsp.plugins.mason" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.cmp" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.signature" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.none_ls" })
  table.insert(specs, { import = "nvim-shared.lsp.bundle", opts = { ensure_installed = servers } })
  table.insert(specs, { import = "nvim-shared.lsp.dap" })

end

require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
