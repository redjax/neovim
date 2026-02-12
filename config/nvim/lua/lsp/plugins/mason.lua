-- Mason plugin: sets up mason and mason-lspconfig. Actual servers to install are passed when core.setup is invoked.
return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    lazy = false,
    opts = function(_, opts)
      -- Function to check if a command exists
      local function has(cmd)
        return vim.fn.executable(cmd) == 1
      end
      
      -- Essential tools for all platforms
      local base_tools = {
        "stylua",              -- Lua formatter
        "shellcheck",          -- Shell script linter
        "shfmt",               -- Shell script formatter
        "prettier",            -- Multi-language formatter (JSON, YAML, Markdown, etc.)
        "marksman",            -- Markdown LSP
        "yaml-language-server", -- YAML LSP
        "json-lsp",            -- JSON LSP
      }
      
      -- Language-specific tools based on availability
      local conditional_tools = {}
      
      -- Python tools (if Python is available)
      if has("python") or has("python3") then
        vim.list_extend(conditional_tools, {
          "pyright",          -- Python LSP
          "flake8",           -- Python linter
          "black",            -- Python formatter
          "isort",            -- Python import sorter
        })
      end
      
      -- Shell tools (if any shell is available)
      if has("bash") or has("sh") or has("zsh") then
        table.insert(conditional_tools, "bash-language-server") -- Bash LSP
      end
      
      -- PowerShell tools (if PowerShell is available)
      if has("pwsh") or has("powershell") then
        table.insert(conditional_tools, "powershell-editor-services") -- PowerShell LSP
      end
      
      -- Node.js tools (if Node is available)
      if has("node") or has("npm") then
        vim.list_extend(conditional_tools, {
          "eslint_d",         -- JavaScript linter
          "typescript-language-server", -- TypeScript LSP
        })
      end
      
      -- Go tools (if Go is available)
      if has("go") then
        vim.list_extend(conditional_tools, {
          "gopls",            -- Go LSP
          "gofumpt",          -- Go formatter
          "goimports",        -- Go import formatter
          "golines",          -- Go line length formatter
        })
      end
      
      -- Rust tools (if Cargo is available)
      if has("cargo") then
        table.insert(conditional_tools, "rust-analyzer")    -- Rust LSP
      end
      
      -- Azure tools (if Azure CLI is available)
      if has("az") or has("dotnet") then
        table.insert(conditional_tools, "bicep-lsp")        -- Azure Bicep LSP
      end
      
      -- Docker tools (if Docker is available)
      if has("docker") then
        vim.list_extend(conditional_tools, {
          "dockerfile-language-server", -- Dockerfile LSP
          "hadolint",         -- Dockerfile linter
        })
      end
      
      -- Terraform
      if has("terraform") then
        vim.list_extend(conditional_tools, {
          "terraform-ls",        -- Terraform LSP
          "tflint",              -- Terraform linter
        })
      end
      
      -- SQL
      if has("psql") or has("mysql") or has("sqlite3") then
        table.insert(conditional_tools, "sqlls")
      end
      
      -- Additional formatters and linters
      table.insert(conditional_tools, "yamllint")            -- YAML linter
      table.insert(conditional_tools, "actionlint")          -- GitHub Actions linter
      
      -- Combine all tools
      local ensure_installed = base_tools
      vim.list_extend(ensure_installed, conditional_tools)
      
      opts.ensure_installed = ensure_installed
      
      -- Add custom registries
      opts.registries = {
        'github:mason-org/mason-registry',
        'github:crashdummyy/mason-registry',
      }
      
      return opts
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
}
