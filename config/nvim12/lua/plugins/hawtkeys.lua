-- Hawtkeys https://github.com/tris203/hawtkeys.nvim

return {
  src = "https://github.com/tris203/hawtkeys.nvim",
  name = "hawtkeys.nvim",

  setup = function()
    local opts = {
      -- leader = " ",
      -- homerow = 2,
      -- powerFingers = { 2, 3, 6, 7 },
      -- keyboardLayout = "qwerty",
      -- highlights = {
      --   HawtkeysMatchGreat = { fg = "green", bold = true },
      --   HawtkeysMatchGood = { fg = "green" },
      --   HawtkeysMatchOk  = { fg = "yellow" },
      --   HawtkeysMatchBad = { fg = "red" },
      -- },
    }
    require("hawtkeys").setup(opts)
  end,
}
