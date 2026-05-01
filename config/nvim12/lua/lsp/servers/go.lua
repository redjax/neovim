return {
  name = "go",
  servers = { "gopls", "golangci_lint_ls" },
  tools = { "gopls", "golangci-lint", "gofumpt", "goimports", "gomodifytags", "impl", "delve" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
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
      env = {
        GOPATH = vim.env.GOPATH or vim.fn.expand("~/go"),
        GOROOT = vim.env.GOROOT or vim.fn.expand("~/.go"),
      },
      directoryFilters = {
        "-**/node_modules",
        "-**/.git",
        "-**/vendor",
      },
    },
  },
}
