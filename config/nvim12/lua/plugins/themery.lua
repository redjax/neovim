-- Themery https://github.com/zaldih/themery.nvim

return {
  src = "https://github.com/zaldih/themery.nvim",
  name = "themery.nvim",
  cmd = "Themery",
  keys = {
    { "<leader>tt", desc = "Open Themery" },
  },
  lazy = true,
  setup = function()
    local catalog = require("themes.catalog")
    local themery = require("themery")
    local menu = require("themes._themery_menu")

    catalog.load()

    themery.setup({
      themes = menu.themes,
      livePreview = true,
    })

    vim.keymap.set("n", "<leader>tt", "<cmd>Themery<cr>", { desc = "Open Themery" })
  end,
}
