-- Wilder (wild menu enhancements) https://github.com/gelguy/wilder.nvim

return {
  "gelguy/wilder.nvim",
  dependencies = {
    "romgrk/fzy-lua-native",  -- optional but recommended
  },
  config = function()
    local wilder = require("wilder")

    -- Setup must come first to initialize internal components
    wilder.setup({
      modes = { ":", "/", "?" },
      enable_cmdline_enter = true,
    })

    -- Fallback logic based on available plugins
    local has_telescope, _ = pcall(require, "telescope")
    local has_snacks, _ = pcall(require, "snacks")
    local has_nui, _ = pcall(require, "nui")

    -- Use popupmenu_renderer if telescope or nui is available
    if has_telescope or has_nui then
      wilder.set_option("renderer", wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { ' ', wilder.popupmenu_buffer() },
        right = { ' ', wilder.popupmenu_scrollbar() },
      }))
    elseif has_snacks then
      wilder.set_option("renderer", wilder.wildmenu_renderer({
        highlighter = wilder.basic_highlighter(),
      }))
    else
      vim.notify("Wilder fallback failed: no renderer backend available", vim.log.levels.WARN)
    end
  end,
}
