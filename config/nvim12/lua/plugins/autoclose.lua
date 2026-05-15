-- Autoclose https://github.com/m4xshen/autoclose.nvim

return {
  src = "https://github.com/m4xshen/autoclose.nvim",
  name = "autoclose.nvim",
  setup = function()
    require("autoclose").setup({
      keys = {
        ["("] = { escape = false, close = true, pair = "()" },
        ["["] = { escape = false, close = true, pair = "[]" },
        ["{"] = { escape = false, close = true, pair = "{}" },

        [">"] = { escape = true, close = false, pair = "<>" },
        [")"] = { escape = true, close = false, pair = "()" },
        ["]"] = { escape = true, close = false, pair = "[]" },
        ["}"] = { escape = true, close = false, pair = "{}" },

        ['"'] = { escape = true, close = true, pair = '""' },
        ["'"] = { escape = true, close = false, pair = "''" },
        ["`"] = { escape = true, close = true, pair = "``" },
      },
      options = {
        disabled_filetypes = { "text", "markdown" },
        disable_when_touch = true,
        touch_regex = "[%w]",
        pair_spaces = false,
        auto_indent = true,
        disable_command_mode = false,
      },
    })
  end,
}
