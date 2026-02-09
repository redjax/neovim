-- nvim-lint - Fast and async linting
-- https://github.com/mfussenegger/nvim-lint

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    
    -- Helper function to check if a tool is available
    local function has_tool(tool)
      return vim.fn.executable(tool) == 1
    end
    
    -- Configure linters by filetype (only if tools are available)
    lint.linters_by_ft = {}
    
    -- Shell scripts
    if has_tool("shellcheck") then
      lint.linters_by_ft.sh = { "shellcheck" }
      lint.linters_by_ft.bash = { "shellcheck" }
    end
    
    -- Python
    if has_tool("flake8") then
      lint.linters_by_ft.python = { "flake8" }
    elseif has_tool("pylint") then
      lint.linters_by_ft.python = { "pylint" }
    end
    
    -- JavaScript/TypeScript
    if has_tool("eslint") then
      lint.linters_by_ft.javascript = { "eslint" }
      lint.linters_by_ft.typescript = { "eslint" }
      lint.linters_by_ft.javascriptreact = { "eslint" }
      lint.linters_by_ft.typescriptreact = { "eslint" }
    end
    
    -- Docker
    if has_tool("hadolint") then
      lint.linters_by_ft.dockerfile = { "hadolint" }
    end
    
    -- YAML
    if has_tool("yamllint") then
      lint.linters_by_ft.yaml = { "yamllint" }
    end
    
    -- Markdown
    if has_tool("markdownlint") then
      lint.linters_by_ft.markdown = { "markdownlint" }
    end
    
    -- GitHub Actions
    if has_tool("actionlint") then
      lint.linters_by_ft.yaml = lint.linters_by_ft.yaml or {}
      -- Only add actionlint for workflow files
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.yml", "*.yaml" },
        callback = function()
          local filepath = vim.fn.expand("%:p")
          if filepath:match("%.github/workflows/") then
            lint.linters_by_ft.yaml = { "actionlint" }
          end
        end,
      })
    end
    
    -- Go
    if has_tool("golangci-lint") then
      lint.linters_by_ft.go = { "golangcilint" }
    end
    
    -- Terraform
    if has_tool("tflint") then
      lint.linters_by_ft.terraform = { "tflint" }
    end
    
    -- Auto-lint on specific events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    
    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}