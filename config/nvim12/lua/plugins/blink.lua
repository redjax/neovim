-- Blink completion engine https://github.com/Saghen/blink.cmp

return {
  src = "https://github.com/Saghen/blink.cmp",
  name = "blink.cmp",
  version = "v1",
  setup = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",  -- default: <C-y>
        ["<Tab>"] = { "select_next", "fallback" },  -- Cycle forward through suggestions
        ["<S-Tab>"] = { "select_prev", "fallback" },  -- Cycle backward through suggestions
        ["<CR>"] = { "accept", "fallback" },  -- Enter to accept or newline
        ["<C-CR>"] = { "accept" }  -- Ctrl+Enter
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "lua" },
    })
  end,
}
