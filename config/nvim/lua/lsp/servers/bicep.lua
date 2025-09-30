return {
  name = "bicep",
  servers = { "bicep" },
  tools = { "bicep-lsp" },
  settings = {
    bicep = {
      -- Enable experimental features
      experimental = {
        resourceTyping = true,
      },
      -- Format settings
      formatter = {
        insertFinalNewline = true,
        indentKind = "Space",
        indentSize = 2,
      },
      -- Completion settings
      completion = {
        showSnippets = true,
        showDescriptions = true,
      },
    },
  },
  filetypes = { "bicep" },
}