return {
  name = "python",
  servers = { "pyright", "ruff_lsp" },
  tools = { "pyright", "ruff", "black", "isort", "mypy", "pylint", "flake8" },
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using ruff
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
    ruff_lsp = {
      init_options = {
        settings = {
          args = {},
        },
      },
    },
  },
}
