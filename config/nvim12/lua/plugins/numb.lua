-- Numb https://github.com/nacro90/numb.nvim

return {
  src = "https://github.com/nacro90/numb.nvim",
  name = "numb.nvim",

  setup = function()
    require("numb").setup({
      show_numbers = true,
      show_cursorline = true,
      hide_relativenumbers = true,
      number_only = false,
      centered_peeking = true,
    })
  end,
}
