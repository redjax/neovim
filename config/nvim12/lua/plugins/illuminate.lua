-- Illuminate https://github.com/RRethy/vim-illuminate

return {
  src = "https://github.com/RRethy/vim-illuminate",
  name = "vim-illuminate",
  setup = function()
    require("illuminate").configure({
      providers = { "lsp", "treesitter", "regex" },
      delay = 100,
      filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
      under_cursor = true,
      min_count_to_highlight = 1,
    })
  end,
}
