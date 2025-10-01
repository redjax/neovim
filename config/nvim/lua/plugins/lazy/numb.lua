-- Numb https://github.com/nacro90/numb.nvim

return {
  'nacro90/numb.nvim',
  config = function()
    require('numb').setup({
      show_numbers = true,          -- show line numbers in peek window
      show_cursorline = true,       -- highlight cursor line in peek
      hide_relativenumbers = true,  -- hide relative numbers in peek
      number_only = false,          -- peek when command starts with number, not only pure number
      centered_peeking = true,      -- peek line will be centered on screen
    })
  end,
}
