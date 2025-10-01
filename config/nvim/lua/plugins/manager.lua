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

-- Base specs
local specs = {
  { import = "plugins.lazy" },
  { import = "themes" },
  { import = "lsp.plugins.mason" },
  { import = "lsp.plugins.signature" },
  { import = "lsp.plugins.none_ls" },
  { import = "lsp.dap" },
}

-- Define LSP servers directly in this profile
local servers = {
  -- Base servers
  "lua_ls",
  "marksman",
  "powershell_es",
  "tflint",

  -- NPM servers
  "azure_pipelines_ls",
  "bashls",
  "docker_compose_language_service",
  "dockerls",
  "gh_actions_ls",
  "jsonls",
  "pyright",
  "sqlls",
  "yamlls",

  -- .NET servers
  "bicep",

  -- Go servers
  "golangci_lint_ls",
  "gopls",
  "sqls",
}

-- Add LSP bundle with the defined servers
table.insert(specs, { import = "lsp.bundle", opts = { ensure_installed = servers } })

-- Finalize lazy.nvim setup
require("lazy").setup({
  spec = specs,
  defaults = {
    lazy = true, -- Make plugins lazy by default
    version = false,
  },
  change_detection = { notify = false },
  checker = { enabled = true, notify = false },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      -- Disable unused runtime plugins for faster startup
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

