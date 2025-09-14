-- YankBank https://github.com/ptdewey/yankbank-nvim

return {
  "ptdewey/yankbank-nvim",
  dependencies = {
    "kkharji/sqlite.lua",
  },
  cmd = { "YankBank" },
  keys = {
    { "y" },
    { "Y", "y$" }, -- redefine Y behavior to y$ to avoid breaking lazy
    { "d" },
    { "D" },
    { "x" },
    { "<leader>p", desc = "Open YankBank" },
  },
  event = { "FocusGained" },
  config = function()
    require("yankbank").setup({
      max_entries = 10,
      sep = "-----",
      num_behavior = "jump",         -- number keys jump to entry
      focus_gain_poll = true,        -- auto add text copied outside Neovim
      persist_type = "sqlite",       -- persist yank history to sqlite db
      keymaps = {
        paste = "<CR>",              -- enter to paste
        paste_back = "P",            -- shift-p to paste before cursor
        yank = "yy",                 -- yank mapping in popup
        close = { "<Esc>", "<C-c>", "q" }, -- keys to close the popup
      },
      registers = {
        yank_register = "+",         -- paste from system clipboard by default
      },
      bind_indices = "<leader>p",    -- keybinding prefix to paste by index
    })

    -- Keymap: Open YankBank popup with <leader>p
    vim.keymap.set("n", "<leader>p", "<cmd>YankBank<CR>", { noremap = true, silent = true, desc = "Open YankBank" })
  end,
}
