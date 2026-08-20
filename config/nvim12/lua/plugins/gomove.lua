-- Gomove line mover https://github.com/booperlv/nvim-gomove

return {
  src = "https://github.com/booperlv/nvim-gomove",
  name = "nvim-gomove",

  setup = function()
    require("gomove").setup({
      map_defaults = true,
      reindent = true,
      undojoin = true,
      move_past_end_col = false,
    })
  end,
}
