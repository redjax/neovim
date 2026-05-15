-- JABS https://github.com/matbme/JABS.nvim

return {
  src = "https://github.com/matbme/JABS.nvim",
  name = "JABS.nvim",

  setup = function()
    require("jabs").setup({
      position = { "right", "bottom" },
      width = 40,
      height = 10,
      border = "rounded",
      preview_position = "bottom",
      preview = {
        width = 40,
        height = 10,
        border = "rounded",
      },
      highlight = {
        current = "Title",
        hidden = "Comment",
        split = "WarningMsg",
        alternate = "CursorLine",
      },
      keymap = {
        close = "d",
        jump = "<cr>",
        h_split = "h",
        v_split = "v",
      },
      symbols = {
        current = "★",
        alternate = "☆",
        split = "⎇",
        hidden = "·",
      },
      use_devicons = true,
    })

    vim.keymap.set("n", "<leader>bb", "<cmd>JABSOpen<cr>", { desc = "Open JABS buffer switcher" })
  end,
}
