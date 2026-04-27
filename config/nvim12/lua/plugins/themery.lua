-- Themery https://github.com/zaldih/themery.nvim

return {
  src = "https://github.com/zaldih/themery.nvim",
  name = "themery.nvim",
  setup = function()
    local themery = require("themery")
    local menu = require("themes._themery_menu")

    themery.setup({
      themes = menu.themes,
      livePreview = true,
    })

    if not vim.g.colors_name or vim.g.colors_name == "" then
      pcall(vim.cmd.colorscheme, menu.default)
    end

    vim.keymap.set("n", "<leader>tt", "<cmd>Themery<cr>", { desc = "Open Themery" })
  end,
}
