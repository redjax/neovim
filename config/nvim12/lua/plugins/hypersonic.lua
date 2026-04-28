-- Hypersonic regex explainer https://github.com/tomiis4/Hypersonic.nvim

return {
  src = "https://github.com/tomiis4/Hypersonic.nvim",
  name = "Hypersonic.nvim",

  setup = function()
    require("hypersonic").setup({
      border = "rounded",
      winblend = 0,
      add_padding = true,
      hl_group = "Keyword",
      wrapping = '"',
      enable_cmdline = true,
    })
  end,
}
