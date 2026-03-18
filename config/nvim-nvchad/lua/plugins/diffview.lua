return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory", "DiffviewRefresh" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
    { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current file)" },
    { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (project)" },
    { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
  },
  opts = {
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
  },
}
