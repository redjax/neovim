-- Auto close and rename HTML/XML tags https://github.com/windwp/nvim-ts-autotag

return {
  src = "https://github.com/windwp/nvim-ts-autotag",
  name = "nvim-ts-autotag",
  setup = function()
    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
      aliases = {
        astro = "html",
        eruby = "html",
        vue = "html",
        htmldjango = "html",
      },
    })
  end,
}
