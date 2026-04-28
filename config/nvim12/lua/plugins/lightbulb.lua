-- Lightbulb https://github.com/kosayoda/nvim-lightbulb

return {
  src = "https://github.com/kosayoda/nvim-lightbulb",
  name = "nvim-lightbulb.nvim",

  setup = function()
    local lightbulb = require("nvim-lightbulb")
    lightbulb.setup({})
  end,
}
