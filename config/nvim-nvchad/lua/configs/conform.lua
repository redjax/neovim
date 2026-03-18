local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

local options = {
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },
  },

  formatters = {},

  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },

  notify_on_error = true,
}

-- Python
if has "isort" or has "black" then
  options.formatters_by_ft.python = { "isort", "black" }
end

-- JavaScript/TypeScript + web (prettier/prettierd)
if has "prettierd" or has "prettier" then
  local prettier = has "prettierd" and "prettierd" or "prettier"
  options.formatters_by_ft.javascript = { prettier }
  options.formatters_by_ft.typescript = { prettier }
  options.formatters_by_ft.javascriptreact = { prettier }
  options.formatters_by_ft.typescriptreact = { prettier }
  options.formatters_by_ft.html = { prettier }
  options.formatters_by_ft.css = { prettier }
  options.formatters_by_ft.scss = { prettier }
  options.formatters_by_ft.json = { prettier }
  options.formatters_by_ft.jsonc = { prettier }
  options.formatters_by_ft.yaml = { prettier }
  options.formatters_by_ft.yml = { prettier }
  options.formatters_by_ft.markdown = { prettier }
end

-- Go
if has "gofumpt" then
  options.formatters_by_ft.go = { "gofumpt", "goimports" }
end

-- Rust
if has "rustfmt" then
  options.formatters_by_ft.rust = { "rustfmt" }
end

-- Shell
if has "shfmt" then
  options.formatters_by_ft.sh = { "shfmt" }
  options.formatters_by_ft.bash = { "shfmt" }
  options.formatters_by_ft.zsh = { "shfmt" }
end

-- PowerShell
if has "pwsh" then
  options.formatters_by_ft.ps1 = { "powershell_es" }
  options.formatters_by_ft.psm1 = { "powershell_es" }
  options.formatters.powershell_es = {
    command = "pwsh",
    args = { "-Command", "Format-Document" },
    stdin = true,
  }
end

-- Terraform
if has "terraform" then
  options.formatters_by_ft.terraform = { "terraform_fmt" }
  options.formatters_by_ft.tf = { "terraform_fmt" }
end

-- SQL
if has "sqlfmt" then
  options.formatters_by_ft.sql = { "sqlfmt" }
end

-- C/C++
if has "clang-format" then
  options.formatters_by_ft.c = { "clang_format" }
  options.formatters_by_ft.cpp = { "clang_format" }
end

-- XML
if has "xmllint" then
  options.formatters_by_ft.xml = { "xmllint" }
end

return options
