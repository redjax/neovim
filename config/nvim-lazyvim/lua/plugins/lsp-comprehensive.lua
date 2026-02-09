-- Comprehensive LSP configuration for multiple languages and file types
-- Covers: Python, PowerShell, Bash, Azure Bicep, DevOps pipelines, GitHub Actions,
-- YAML, CSV, Go, Markdown, SQL, Terraform, Docker/Dockerfile

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  opts = function(_, opts)
    local function has(cmd)
      return vim.fn.executable(cmd) == 1
    end
    
    opts.servers = opts.servers or {}
    
    -- YAML LSP - essential for Azure DevOps, GitHub Actions, Kubernetes, etc.
    opts.servers.yamlls = {
      settings = {
        yaml = {
          hover = true,
          completion = true,
          validate = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemas = {
            -- Azure DevOps Pipelines
            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
              "azure-pipelines.yml",
              "azure-pipelines.yaml",
              ".azure-pipelines.yml",
              ".azure-pipelines.yaml",
              "pipelines/*.yml",
              "pipelines/*.yaml",
              ".azure/pipelines/*.yml",
              ".azure/pipelines/*.yaml",
            },
            -- GitHub Actions
            ["https://json.schemastore.org/github-workflow.json"] = {
              ".github/workflows/*.yml",
              ".github/workflows/*.yaml",
            },
            -- GitHub Action (single)
            ["https://json.schemastore.org/github-action.json"] = {
              "action.yml",
              "action.yaml",
            },
            -- Docker Compose
            ["https://json.schemastore.org/docker-compose.json"] = {
              "docker-compose.yml",
              "docker-compose.yaml",
              "compose.yml",
              "compose.yaml",
            },
            -- Kubernetes
            ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
            ["https://kubernetesjsonschema.dev/v1.18.0-standalone-strict/all.json"] = "*.k8s.yaml",
          },
        },
      },
    }

    -- Terraform LSP
    opts.servers.terraformls = {
      filetypes = { "terraform", "tf", "terraform-vars" },
      settings = {
        terraform = {
          validate = true,
        },
      },
    }

    -- Dockerfile LSP
    opts.servers.dockerls = {
      filetypes = { "dockerfile" },
      settings = {
        docker = {
          languageserver = {
            formatter = {
              ignoreMultilineInstructions = true,
            },
          },
        },
      },
    }

    -- Azure Bicep LSP (when Azure CLI is available)
    if has("az") then
      opts.servers.bicep = {
        filetypes = { "bicep" },
        settings = {},
      }
    end

    -- Markdown LSP
    opts.servers.marksman = {
      filetypes = { "markdown", "md" },
      settings = {},
    }

    -- Go LSP (enhanced configuration)
    if has("go") then
      opts.servers.gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
              fieldalignment = true,
              nilness = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            -- Environment settings
            env = {
              GOPATH = vim.env.GOPATH or vim.fn.expand("~/go"),
              GOROOT = vim.env.GOROOT or vim.fn.expand("~/.go"),
            },
            allowModfileModifications = true,
          },
        },
      }
    end

    -- SQL LSPs
    opts.servers.sqlls = {
      filetypes = { "sql", "mysql", "pgsql" },
      settings = {},
    }

    -- Enhanced Python LSP
    if has("python") or has("python3") then
      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      }
    end

    -- JSON LSP with schema support for various file types
    opts.servers.jsonls = {
      settings = {
        json = {
          schemas = {
            {
              fileMatch = { "package.json" },
              url = "https://json.schemastore.org/package.json",
            },
            {
              fileMatch = { "tsconfig*.json" },
              url = "https://json.schemastore.org/tsconfig.json",
            },
            {
              fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
              url = "https://json.schemastore.org/prettierrc.json",
            },
            {
              fileMatch = { ".eslintrc", ".eslintrc.json" },
              url = "https://json.schemastore.org/eslintrc.json",
            },
            {
              fileMatch = { "azure-pipelines.json", ".azure-pipelines.json" },
              url = "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json",
            },
          },
        },
      },
    }

    -- CSV LSP (using rainbow_csv for syntax highlighting)
    -- Note: This is handled by the rainbow_csv plugin, not LSP

    return opts
  end,
}