-- Tiny inline diagnostic https://github.com/rachartier/tiny-inline-diagnostic.nvim

return {
  src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  name = "tiny-inline-diagnostic.nvim",

  setup = function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      transparent_bg = false,
      transparent_cursorline = false,
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "NonText",
        background = "CursorLine",
        mixing_color = "None",
      },
      options = {
        show_source = { enabled = false, if_many = false },
        use_icons_from_diagnostic = false,
        set_arrow_to_diag_color = false,
        add_messages = true,
        throttle = 20,
        softwrap = 30,
      },
    })

    vim.diagnostic.config({ virtual_text = false })
  end,
}
