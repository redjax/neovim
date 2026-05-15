-- LuaSnip snippet engine https://github.com/L3MON4D3/LuaSnip

return {
  src = "https://github.com/L3MON4D3/LuaSnip",
  name = "LuaSnip",
  setup = function()
    -- Load VS Code-style snippets from friendly-snippets lazily.
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
