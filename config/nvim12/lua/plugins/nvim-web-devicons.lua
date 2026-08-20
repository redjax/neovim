-- nvim-web-devicons https://github.com/nvim-tree/nvim-web-devicons

return {
  src = "https://github.com/nvim-tree/nvim-web-devicons",
  name = "nvim-web-devicons",
  setup = function()
    require("nvim-web-devicons").setup({
      color_icons = true,
      default = true,
      strict = true,
    })
  end,
}
