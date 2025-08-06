-- JABS https://github.com/matbme/JABS.nvim

return {
    "matbme/JABS.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- "VeryLazy", "BufWinEnter" or "VimEnter" as you prefer
    event = "VimEnter",
    config = function()
      require("jabs").setup({
        -- {"center", "center"}, {"right", "bottom"}, etc.
        -- position = { "center", "center" },
        position = { "right", "bottom"},
        width = 40,
        height = 10,
        -- "single", "double", "shadow", "rounded", "none"
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
          -- delete buffer
          close = "d",
          -- jump to buffer
          jump = "<cr>",
          -- horizontal split
          h_split = "h",
          -- vertical split
          v_split = "v",
        },
        symbols = {
          -- symbol for the current buffer
          current = "★",
          -- symbol for the alternate buffer
          alternate = "☆",
          -- symbol for visible/split buffers
          split = "⎇",
          -- symbol for hidden buffers
          hidden = "·",
        },
        use_devicons = true
      })
      -- Keymap to toggle JABS window (change <leader>bb to your preference)
      vim.keymap.set("n", "<leader>bb", "<cmd>JABSOpen<cr>", { desc = "Open JABS buffer switcher" })
    end,
}
