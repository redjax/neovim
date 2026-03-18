return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure {
      providers = { "lsp", "treesitter", "regex" },
      delay = 100,
      filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree" },
      under_cursor = true,
      min_count_to_highlight = 1,
    }
  end,
}
