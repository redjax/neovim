-- Auto-mkdir https://github.com/mateuszwieloch/automkdir.nvim

vim.pack.add({
  { src = "https://github.com/mateuszwieloch/automkdir.nvim", },
})

return {
  setup = function()
    vim.schedule(function()
      require("automkdir").setup({
        blacklist = {
          filetype = {
            "help",
            "nofile",
            "quickfix",
            "gitcommit",
            "TelescopePrompt",
            "NvimTree",
            "dashboard",
            "alpha",
            "starter",
            "lazy",
            "lazygit",
            "oil",
            "netrw",
          },
          buftype = {
            "nofile",
            "terminal",
            "quickfix",
          },
          pattern = {},
        },
      })
    end)
  end,
}

