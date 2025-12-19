local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local specs = {
  { import = "plugins.lazy" },
  { import = "themes" },
  { import = "lsp.plugins.mason" },
  { import = "lsp.plugins.signature" },
  { import = "lsp.plugins.none_ls" },
  { import = "lsp.dap" },
}

-- Define LSP servers directly in this profile
-- Helper function to check if a command exists
local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

local servers = {
  -- Base servers (always install)
  "lua_ls",
  "marksman",
  "jsonls",
  "yamlls",
}

-- Conditionally add servers based on what's installed
if has("pwsh") or has("powershell") then
  table.insert(servers, "powershell_es")
end

if has("terraform") then
  table.insert(servers, "tflint")
end

if has("node") or has("npm") then
  vim.list_extend(servers, {
    "azure_pipelines_ls",
    "gh_actions_ls",
  })
end

if has("bash") or has("sh") then
  table.insert(servers, "bashls")
end

if has("docker") then
  vim.list_extend(servers, {
    "docker_compose_language_service",
    "dockerls",
  })
end

if has("python") or has("python3") then
  table.insert(servers, "pyright")
end

if has("dotnet") then
  table.insert(servers, "bicep")
end

if has("go") then
  vim.list_extend(servers, {
    "golangci_lint_ls",
    "gopls",
  })
end

if has("psql") or has("mysql") or has("sqlite3") then
  table.insert(servers, "sqlls")
  table.insert(servers, "sqls")
end

if has("cargo") or has("rustc") then
  table.insert(servers, "rust_analyzer")
end

-- Add LSP bundle with the defined servers
table.insert(specs, { import = "lsp.bundle", opts = { ensure_installed = servers } })

-- Setup lazy.nvim
require("lazy").setup({
  spec = specs,
  defaults = {
    lazy = true, -- Make plugins lazy by default
    version = false,
  },
  change_detection = { notify = false },
  checker = { enabled = true, notify = false, frequency = 86400 },
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
