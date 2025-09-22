-- Poimandres theme https://github.com/olivercederborg/poimandres.nvim

return {
  "olivercederborg/poimandres.nvim",
  name = "poimandres",
  lazy = true,  -- Let Themery manage loading
  priority = 1000,
  config = function()
    require('poimandres').setup {
      bold_vert_split = false, -- use bold vertical separators
      dim_nc_background = false, -- dim 'non-current' window backgrounds
      disable_background = false, -- disable background
      disable_float_background = false, -- disable background for floats
      disable_italics = false, -- disable italics
    }
  end,
}