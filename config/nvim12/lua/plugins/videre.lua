-- Videre https://github.com/Owen-Dechow/videre.nvim

return {
  src = "https://github.com/Owen-Dechow/videre.nvim",
  name = "videre.nvim",

  setup = function()
    require("videre").setup({
      round_units = false,
      -- optional: statusline handled by your config, not the plugin
      -- simple_statusline = false,
    })
  end,
}
