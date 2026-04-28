return {
  name = "python",
  servers = { "pyright", "ruff" },
  tools = { "pyright", "ruff", "black", "isort", "mypy", "pylint", "flake8" },
  settings = {
    pyright = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
    ruff = {
      init_options = {
        settings = {
          args = {},
        },
      },
    },
  },
}
