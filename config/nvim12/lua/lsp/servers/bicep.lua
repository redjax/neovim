return {
  name = "bicep",
  servers = { "bicep" },
  tools = { "bicep-lsp" },
  settings = {
    bicep = {
      experimental = {
        resourceTyping = true,
      },
      formatter = {
        insertFinalNewline = true,
        indentKind = "Space",
        indentSize = 2,
      },
      completion = {
        showSnippets = true,
        showDescriptions = true,
      },
    },
  },
  filetypes = { "bicep" },
}
