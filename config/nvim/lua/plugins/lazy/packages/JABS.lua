-- JABS https://github.com/matbme/JABS.nvim

return {
    enabled = true,
    "matbme/JABS.nvim",
    -- "VeryLazy", "BufWinEnter" or "VimEnter" as you prefer
    event = "VeryLazy",
    config = function()
      require("jabs").setup({
        -- {"center", "center"}, {"right", "bottom"}, etc.
        position = { "center", "center" },
        width = 80,
        height = 20,
        -- "single", "double", "shadow", "rounded", "none"
        border = "rounded",
        preview_position = "top",
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
        symbols = {
          current = "",
          split = "",
          alternate = "",
          hidden = "﬘"
        },
        keymap = {
          -- delete buffer
          close = "d",
          -- jump to buffer
          jump = "<cr>",
          -- horizontal split
          h_split = "h",
          -- vertical split
          v_split = "v",
        },
        use_devicons = true
      })
      -- Keymap to toggle JABS window (change <leader>bb to your preference)
      vim.keymap.set("n", "<leader>bb", "<cmd>JABSOpen<cr>", { desc = "Open JABS buffer switcher" })
    end,
}
  