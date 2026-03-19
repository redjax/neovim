return {
  name = "yaml",
  servers = { "yamlls" },
  tools = { "yaml-language-server", "yamllint", "actionlint" },
  settings = {
    yamlls = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        kubernetes = "*.yaml",
        -- GitHub Actions (workflows)
        ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
        -- GitHub Actions (single action)
        ["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
        -- Azure Pipelines
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "azure-pipelines.yml",
          "azure-pipelines.yaml",
        },
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        -- Docker Compose
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "*docker-compose*.{yml,yaml}",
          "docker-compose*.{yml,yaml}",
          "compose*.{yml,yaml}",
        },
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
        -- Woodpecker CI
        ["https://raw.githubusercontent.com/woodpecker-ci/woodpecker/main/pipeline/frontend/yaml/linter/schema/schema.json"] = {
          "**/.woodpecker/**.yml",
          "**/.woodpecker.yml",
          "**/.woodpecker/**.yaml",
          "**/.woodpecker.yaml",
        },
      },
      validate = true,
      completion = true,
      hover = true,
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
      },
    },
  },
  filetypes = { "yaml", "yml" },
}