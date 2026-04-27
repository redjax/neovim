-- Auto-mkdir https://github.com/mateuszwieloch/automkdir.nvim

return {
  src = "https://github.com/mateuszwieloch/automkdir.nvim",
  name = "automkdir.nvim",
  setup = function()
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
  end,
}

