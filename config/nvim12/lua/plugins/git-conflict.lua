-- Git conflict https://github.com/akinsho/git-conflict.nvim

return {
  src = "https://github.com/akinsho/git-conflict.nvim",
  name = "git-conflict.nvim",
  version = "main",

  setup = function()
    require("git-conflict").setup({
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    })
  end,
}
