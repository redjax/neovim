-- Comment toggling keybindings
-- LazyVim includes mini.comment by default with gcc/gc mappings
-- This just adds VSCode-like CTRL+/ keybindings

return {
  -- Configure mini.comment
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = nil,
        ignore_blank_line = false,
        start_of_line = false,
        pad_comment_parts = true,
      },
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        comment_visual = "gc",
        textobject = "gc",
      },
    },
    keys = {
      -- VSCode-like CTRL+/ keybindings
      { "<C-/>", "gcc", desc = "Toggle comment", mode = "n", remap = true },
      { "<C-/>", "gc", desc = "Toggle comment", mode = "v", remap = true },
      { "<C-/>", "<Esc>gcca", desc = "Toggle comment", mode = "i", remap = true },
    },
  },
}
