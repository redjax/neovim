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
    opts = {
      ensure_installed = {
        "lua_ls",
        "html",
        "cssls",
        "pyright",
        "gopls",
        "rust_analyzer",
        "bashls",
        "yamlls",
        "jsonls",
        "dockerls",
        "docker_compose_language_service",
        "terraformls",
        "powershell_es",
        "bicep",
        "sqlls",
        "eslint",
      },
      automatic_installation = true,
    },
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
