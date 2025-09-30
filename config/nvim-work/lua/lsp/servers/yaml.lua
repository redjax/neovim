-- YAML Language Server configuration with DevOps schemas
-- Supports Azure DevOps, GitHub Actions, Docker Compose, and Kubernetes

return {
  name = "yaml",
  servers = { "yamlls" },
  config = function()
    return {
      yamlls = {
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
    }
  end,
}