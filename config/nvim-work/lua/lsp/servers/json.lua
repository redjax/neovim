-- JSON Language Server configuration with schemas
-- Supports various JSON configuration files

return {
  name = "json",
  servers = { "jsonls" },
  config = function()
    return {
      jsonls = {
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
    }
  end,
}