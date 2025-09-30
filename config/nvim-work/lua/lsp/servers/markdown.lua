return {
  name = "markdown",
  servers = {}, -- Disable marksman for now since it's causing crashes
  tools = { "prettier" },
  settings = {},
  filetypes = { "markdown", "md" },
  -- Disabled until marksman issues are resolved
  condition = function()
    return false -- Completely disable for now
  end,
}