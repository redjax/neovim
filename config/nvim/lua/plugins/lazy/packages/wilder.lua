-- Wilder wild menu https://github.com/gelguy/wilder.nvim

return {
  "gelguy/wilder.nvim",
  dependencies = {
    "romgrk/fzy-lua-native",  -- optional but recommended for performance
  },
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })

    local has_telescope, _ = pcall(require, "telescope")
    local has_snacks, _ = pcall(require, "snacks")
    local has_nui, _ = pcall(require, "nui")

    if has_telescope then
      wilder.set_option("renderer", wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { ' ', wilder.popupmenu_buffer() },
        right = { ' ', wilder.popupmenu_scrollbar() },
      }))
    elseif has_snacks then
      wilder.set_option("renderer", wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
      }))
    elseif has_nui then
      wilder.set_option("renderer", wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { ' ', wilder.popupmenu_buffer() },
        right = { ' ', wilder.popupmenu_scrollbar() },
      }))
    else
      vim.notify("Wilder fallback failed: no renderer backend available", vim.log.levels.WARN)
    end
  end,
}

