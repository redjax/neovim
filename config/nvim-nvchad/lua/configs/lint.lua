local lint = require "lint"

-- Check if a tool is available (system PATH or Mason bin)
local function has_tool(tool)
  if vim.fn.executable(tool) == 1 then
    return true
  end
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/" .. tool
  if vim.fn.executable(mason_bin) == 1 then
    return true
  end
  return false
end

-- Configure linters by filetype (only if tools are available)
lint.linters_by_ft = {}

-- Shell scripts
if has_tool "shellcheck" then
  lint.linters_by_ft.sh = { "shellcheck" }
  lint.linters_by_ft.bash = { "shellcheck" }
end

-- Python
if has_tool "flake8" then
  lint.linters_by_ft.python = { "flake8" }
elseif has_tool "pylint" then
  lint.linters_by_ft.python = { "pylint" }
elseif has_tool "ruff" then
  lint.linters_by_ft.python = { "ruff" }
end

-- JavaScript/TypeScript
if has_tool "eslint" then
  lint.linters_by_ft.javascript = { "eslint" }
  lint.linters_by_ft.typescript = { "eslint" }
  lint.linters_by_ft.javascriptreact = { "eslint" }
  lint.linters_by_ft.typescriptreact = { "eslint" }
end

-- Docker
if has_tool "hadolint" then
  lint.linters_by_ft.dockerfile = { "hadolint" }
end

-- YAML
if has_tool "yamllint" then
  lint.linters_by_ft.yaml = { "yamllint" }
end

-- Markdown
if has_tool "markdownlint" then
  lint.linters_by_ft.markdown = { "markdownlint" }
end

-- GitHub Actions (smart detection for workflow files)
if has_tool "actionlint" then
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.yml", "*.yaml" },
    callback = function()
      local filepath = vim.fn.expand "%:p"
      if filepath:match "%.github/workflows/" then
        lint.linters_by_ft.yaml = { "actionlint" }
        lint.try_lint()
      end
    end,
  })
end

-- Terraform
if has_tool "tflint" then
  lint.linters_by_ft.terraform = { "tflint" }
end

-- JSON
if has_tool "jsonlint" then
  lint.linters_by_ft.json = { "jsonlint" }
end

-- SQL
if has_tool "sqlfluff" then
  lint.linters_by_ft.sql = { "sqlfluff" }
end

-- C/C++
if has_tool "cppcheck" then
  lint.linters_by_ft.c = { "cppcheck" }
  lint.linters_by_ft.cpp = { "cppcheck" }
end

-- Vim script
if has_tool "vint" then
  lint.linters_by_ft.vim = { "vint" }
end

-- Auto-lint on write and leaving insert mode
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Manual lint command
vim.api.nvim_create_user_command("Lint", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })
