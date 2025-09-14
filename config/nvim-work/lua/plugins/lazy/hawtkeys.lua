-- Hawtkeys https://github.com/tris203/hawtkeys.nvim

return {
    "tris203/hawtkeys.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "Hawtkeys", "HawtkeysAll", "HawtkeysDupes" },
    opts = {
      -- Optional: customize as needed, or leave empty for defaults
      -- leader = " ", -- your leader key (default is space)
      -- homerow = 2, -- row to use as home row (default 2)
      -- powerFingers = { 2, 3, 6, 7 }, -- fingers to prioritize (default)
      -- keyboardLayout = "qwerty", -- or "dvorak", "colemak", etc.
      -- highlights = {
      --   HawtkeysMatchGreat = { fg = "green", bold = true },
      --   HawtkeysMatchGood = { fg = "green" },
      --   HawtkeysMatchOk = { fg = "yellow" },
      --   HawtkeysMatchBad = { fg = "red" },
      -- },
    },
    config = function(_, opts)
      require("hawtkeys").setup(opts)
    end,
}
  