-- Lualine https://github.com/nvim-lualine/lualine.nvim

vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim", },
})

return {
  setup = function()
    vim.schedule(function()
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
    end)
  end,
}

