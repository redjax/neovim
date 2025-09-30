return {
  name = "go",
  servers = { "gopls", "golangci_lint_ls", "sqls" },
  tools = { "gopls", "golangci-lint", "gofumpt", "goimports", "gomodifytags", "impl", "delve" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
        fieldalignment = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      gofumpt = true,
      semanticTokens = true,
      usePlaceholders = true,
      completeUnimported = true,
      matcher = "fuzzy",
      experimentalPostfixCompletions = true,
      buildFlags = { "-tags", "integration" },
    },
  },
}
