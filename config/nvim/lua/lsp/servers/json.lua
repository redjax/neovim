return {
  name = "json",
  servers = { "jsonls" },
  tools = { "json-lsp", "prettier" },
  settings = {
    jsonls = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
      format = {
        enable = true,
      },
    },
  },
  filetypes = { "json", "jsonc" },
}