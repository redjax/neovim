return {
  name = "json",
  servers = { "jsonls" },
  tools = { "json-lsp", "prettier" },
  settings = {
    jsonls = {
      schemas = (function()
        local ok, schemastore = pcall(require, "schemastore")
        if ok and schemastore and schemastore.json and schemastore.json.schemas then
          return schemastore.json.schemas()
        end
        return {}
      end)(),
      validate = { enable = true },
      format = {
        enable = true,
      },
    },
  },
  filetypes = { "json", "jsonc" },
}
