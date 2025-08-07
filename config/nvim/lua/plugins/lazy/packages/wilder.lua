-- Wilder wild menu https://github.com/gelguy/wilder.nvim

return {
  "gelguy/wilder.nvim",
  dependencies = {
    "romgrk/fzy-lua-native",  -- optional but recommended for performance
  },
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })

    wilder.set_option("renderer", wilder.popupmenu_renderer({
      highlighter = wilder.basic_highlighter(),
      left = { ' ', wilder.popupmenu_buffer() },
      right = { ' ', wilder.popupmenu_scrollbar() },
    }))
  end,
}
