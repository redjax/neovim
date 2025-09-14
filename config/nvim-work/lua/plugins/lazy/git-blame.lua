-- Git blame https://github.com/f-person/git-blame.nvim

return {
  "f-person/git-blame.nvim",
  lazy = false, -- or true with an event like "BufReadPost"
  config = function()
    vim.g.gitblame_enabled = 1
    vim.g.gitblame_message_template = "<summary> • <date> • <author>"
    vim.g.gitblame_date_format = "%Y-%m-%d"
    vim.g.gitblame_virtual_text_column = 1
  end,
  keys = {
    { "<leader>gbu", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
    { "<leader>gbe", "<cmd>GitBlameEnable<cr>", desc = "Enable git blame" },
    { "<leader>gbd", "<cmd>GitBlameDisable<cr>", desc = "Disable git blame" },
    { "<leader>gbh", "<cmd>GitBlameCopySHA<cr>", desc = "Copy commit SHA" },
    { "<leader>gbl", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy commit URL" },
    { "<leader>gbo", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open file in browser" },
    { "<leader>gbc", "<cmd>GitBlameCopyFileURL<cr>", desc = "Copy file URL" },
  }
}
