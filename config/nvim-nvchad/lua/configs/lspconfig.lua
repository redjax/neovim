require("nvchad.configs.lspconfig").defaults()

-- Servers with custom settings
vim.lsp.config("pyright", {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
})

vim.lsp.config("gopls", {
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
      directoryFilters = {
        "-**/node_modules",
        "-**/.git",
        "-**/vendor",
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        kubernetes = "*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "*docker-compose*.{yml,yaml}",
          "docker-compose*.{yml,yaml}",
          "compose*.{yml,yaml}",
        },
      },
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      validate = { enable = true },
      format = { enable = true },
    },
  },
})

vim.lsp.config("dockerls", {
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = false,
        },
      },
    },
  },
})

vim.lsp.config("terraformls", {
  settings = {
    experimentalFeatures = {
      validateOnSave = true,
      prefillRequiredFields = true,
    },
  },
})

vim.lsp.config("powershell_es", {
  settings = {
    powershell = {
      codeFormatting = {
        preset = "OTBS",
        openBraceOnSameLine = true,
        newLineAfterOpenBrace = true,
        newLineAfterCloseBrace = true,
        pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
        whitespaceBeforeOpenBrace = true,
        whitespaceBeforeOpenParen = true,
        whitespaceAroundOperator = true,
        whitespaceAfterSeparator = true,
        ignoreOneLineBlock = true,
        alignPropertyValuePairs = true,
      },
      scriptAnalysis = {
        enable = true,
      },
    },
  },
})

vim.lsp.config("bicep", {
  settings = {
    bicep = {
      experimental = { resourceTyping = true },
      formatter = {
        insertFinalNewline = true,
        indentKind = "Space",
        indentSize = 2,
      },
    },
  },
})

-- Enable all servers
vim.lsp.enable {
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
}
