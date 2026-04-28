-- Hop motions https://github.com/smoka7/hop.nvim

return {
  src = "https://github.com/smoka7/hop.nvim",
  name = "hop.nvim",
  version = "main",

  setup = function()
    local opts = {
      keys = "etovxqpdygfblzhckisuran",
    }
    require("hop").setup(opts)
  end,
}
