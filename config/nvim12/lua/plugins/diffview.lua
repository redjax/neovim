-- Diffview https://github.com/sindrets/diffview.nvim

return {
  src = "https://github.com/sindrets/diffview.nvim",
  name = "diffview.nvim",
  setup = function()
    require("diffview").setup({
      -- You can customize options here, see :h diffview-config
      use_icons = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
          merge_tool = {
          layout = "diff3_horizontal",
          winbar_info = true,
        },
          file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
    })

        -- Recommended keymaps for quick access
        vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
        vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", { desc = "File History (current file)" })
        vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "File History (project)" })
        vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
  end,
}
