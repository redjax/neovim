return {
  name = "markdown",
  servers = {},
  tools = { "prettier" },
  settings = {},
  filetypes = { "markdown", "md" },
  condition = function()
    return false
  end,
}
