-- Stop insert csessh/stopinsert.nvim

return {
  "csessh/stopinsert.nvim",
  event = { "InsertEnter" },  -- lazy load on entering Insert mode
  dependencies = {
    "saghen/blink.cmp",
  },
  opts = {
    idle_time_ms = 5000,       -- idle for 5000ms (5 seconds) before forcing normal mode
    show_popup_msg = true,     -- show popup message when forced out
    clear_popup_ms = 5000,     -- popup message lasts 5000ms before disappearing
    disabled_filetypes = {      -- filetypes where plugin is disabled
      "TelescopePrompt",
      "checkhealth",
      "help",
      "lspinfo",
      "mason",
      "neo%-tree*",
    },
    guard_func = function()     -- optional guard function to prevent forced exit if true
      return require("blink.cmp").is_documentation_visible()
    end,
  },
}
