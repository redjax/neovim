-- Gomove line mover https://github.com/booperlv/nvim-gomove

return {
  "booperlv/nvim-gomove",
  config = function()
    require("gomove").setup {
      map_defaults = true,   -- enable default smart keybindings
      reindent = true,       -- reindent lines moved vertically
      undojoin = true,       -- join undo for same direction moves
      move_past_end_col = false, -- don't move past end column horizontally
    }
  end,
}
