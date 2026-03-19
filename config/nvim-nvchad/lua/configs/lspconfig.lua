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
      schemas = require('schemastore').yaml.schemas(),
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
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
-- Servers requiring specific toolchains are conditional
local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

local servers = {
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

vim.lsp.enable(servers)
