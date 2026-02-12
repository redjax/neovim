-- Automatic tool installation on startup
-- Eliminates the need for manual install scripts

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      -- Function to check if a command exists
      local function has(cmd)
        return vim.fn.executable(cmd) == 1
      end

      -- Build tool list dynamically based on what's available
      local tools = {
        -- === Core Tools (always install) ===
        "stylua",           -- Lua formatter
        "shellcheck",       -- Shell linter
        "shfmt",            -- Shell formatter
        "marksman",         -- Markdown LSP
        
        -- === Multi-language Tools ===
        "prettier",         -- JSON/YAML/Markdown/CSS/HTML formatter
        "yaml-language-server",
        "json-lsp",
        "taplo",            -- TOML LSP
      }

      -- === Python Tools ===
      if has("python") or has("python3") then
        vim.list_extend(tools, {
          "pyright",
          "ruff",           -- Fast Python linter/formatter
          "black",
          "isort",
          "mypy",
        })
      end

      -- === Node.js/JavaScript/TypeScript Tools ===
      if has("node") or has("npm") then
        vim.list_extend(tools, {
          "typescript-language-server",
          "eslint_d",
          "prettier",
        })
      end

      -- === Go Tools ===
      if has("go") then
        vim.list_extend(tools, {
          "gopls",
          "gofumpt",
          "goimports",
          "golines",
          "golangci-lint",
        })
      end

      -- === Rust Tools ===
      if has("cargo") then
        vim.list_extend(tools, {
          "rust-analyzer",
        })
      end

      -- === Shell/Bash Tools ===
      if has("bash") or has("sh") then
        vim.list_extend(tools, {
          "bash-language-server",
        })
      end

      -- === Docker/Container Tools ===
      if has("docker") then
        vim.list_extend(tools, {
          "dockerfile-language-server",
          "docker-compose-language-service",
          "hadolint",
        })
      end

      -- === Infrastructure as Code ===
      if has("terraform") then
        vim.list_extend(tools, {
          "terraform-ls",
          "tflint",
        })
      end

      if has("az") then
        vim.list_extend(tools, {
          "bicep-lsp",
        })
      end

      -- === DevOps/CI/CD Tools ===
      vim.list_extend(tools, {
        "actionlint",       -- GitHub Actions linter
        "yamllint",
      })

      -- === SQL Tools ===
      vim.list_extend(tools, {
        "sqlls",
        "sqlfmt",
      })

      -- === PowerShell ===
      if has("pwsh") or has("powershell") then
        vim.list_extend(tools, {
          "powershell-editor-services",
        })
      end

      return {
        ensure_installed = tools,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 24,
      }
    end,
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
      
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function()
          vim.notify("Mason tools installation complete!", vim.log.levels.INFO)
        end,
      })
    end,
  },
}
