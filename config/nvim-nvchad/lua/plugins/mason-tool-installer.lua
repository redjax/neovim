return {
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
}
