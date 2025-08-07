-- Tiny inline diagnostic https://github.com/rachartier/tiny-inline-diagnostic.nvim

return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach", -- "LspAttach" or "VeryLazy" if you prefer
  priority = 1000,     -- ensures it loads early
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern", -- options: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
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

    -- Required to disable default virtual text diagnostics
    vim.diagnostic.config({ virtual_text = false })
  end,
}
