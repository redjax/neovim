return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      local function has(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local servers = {
        "lua_ls",
        "html",
        "cssls",
        "bashls",
        "yamlls",
        "jsonls",
        "dockerls",
        "docker_compose_language_service",
        "eslint",
        "sqlls",
      }

      if has "python3" or has "python" then table.insert(servers, "pyright") end
      if has "go" then table.insert(servers, "gopls") end
      if has "rustc" then table.insert(servers, "rust_analyzer") end
      if has "terraform" then table.insert(servers, "terraformls") end
      if has "pwsh" or has "powershell" then table.insert(servers, "powershell_es") end
      if has "bicep" or has "az" then table.insert(servers, "bicep") end

      -- Exclude servers whose toolchains aren't installed
      local exclude = {}
      if not has "rustc" then table.insert(exclude, "rust_analyzer") end
      if not has "go" then table.insert(exclude, "gopls") end
      if not (has "python3" or has "python") then table.insert(exclude, "pyright") end
      if not has "terraform" then table.insert(exclude, "terraformls") end
      if not (has "pwsh" or has "powershell") then table.insert(exclude, "powershell_es") end
      if not (has "bicep" or has "az") then table.insert(exclude, "bicep") end

      return {
        ensure_installed = servers,
        automatic_installation = true,
        automatic_enable = {
          exclude = exclude,
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "black",
        "isort",
        "prettier",
        "shfmt",
        -- Linters
        "shellcheck",
        "flake8",
        "hadolint",
        "yamllint",
        "markdownlint",
        "actionlint",
        "jsonlint",
      },
    },
  },
}
