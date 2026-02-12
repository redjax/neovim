-- Automatic tool installation on startup
-- Eliminates the need for manual install scripts

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
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
          "ruff-lsp",
          "black",
          "isort",
          "mypy",
          "debugpy",        -- Python debugger
        })
      end

      -- === Node.js/JavaScript/TypeScript Tools ===
      if has("node") or has("npm") then
        vim.list_extend(tools, {
          "typescript-language-server",
          "eslint_d",
          "prettier",
          "js-debug-adapter",
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
          "delve",          -- Go debugger
        })
      end

      -- === Rust Tools ===
      if has("cargo") then
        vim.list_extend(tools, {
          "rust-analyzer",
          "codelldb",       -- Rust/C++ debugger
        })
      end

      -- === Shell/Bash Tools ===
      if has("bash") or has("sh") then
        vim.list_extend(tools, {
          "bash-language-server",
          "bash-debug-adapter",
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

      -- === Additional Linters/Formatters ===
      if has("pwsh") or has("powershell") then
        vim.list_extend(tools, {
          "powershell-editor-services",
        })
      end

      return {
        ensure_installed = tools,
        auto_update = false,  -- Set to true if you want auto-updates
        run_on_start = true,  -- Auto-install missing tools on startup
        start_delay = 3000,   -- Delay in ms before starting (prevents lag on startup)
        debounce_hours = 24,  -- Only check once per day
      }
    end,
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
      
      -- Optional: Show notification when installation is complete
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function()
          vim.notify("Mason tools updated!", vim.log.levels.INFO)
        end,
      })
    end,
  },

  -- Update mason.nvim config to work with tool-installer
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 10,  -- Speed up installation
    },
  },
}
