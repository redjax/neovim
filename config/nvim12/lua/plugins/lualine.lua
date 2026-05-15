-- Lualine https://github.com/nvim-lualine/lualine.nvim

return {
  src = "https://github.com/nvim-lualine/lualine.nvim",
  name = "lualine.nvim",
  setup = function()
    require("lualine").setup({
      sections = {
        lualine_c = {
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return require("nvim-navic").is_available()
            end,
          },
        },
      },
    })
  end,
}

