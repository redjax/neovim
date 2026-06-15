-- Active startup theme for nvim12.
-- Keep startup to one theme plugin; full catalog is loaded on demand via Themery.

return {
  src = "https://github.com/rebelot/kanagawa.nvim",
  name = "kanagawa",
  lazy = false,
  setup = function()
    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function()
        return {}
      end,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    })

    pcall(vim.cmd.colorscheme, "kanagawa-wave")
  end,
}
