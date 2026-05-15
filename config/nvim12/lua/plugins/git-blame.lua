-- Git blame https://github.com/f-person/git-blame.nvim

return {
  src = "https://github.com/f-person/git-blame.nvim",
  name = "git-blame.nvim",

  setup = function()
    vim.g.gitblame_enabled = 1
    vim.g.gitblame_message_template = "<summary> • <date> • <author>"
    vim.g.gitblame_date_format = "%Y-%m-%d"
    vim.g.gitblame_virtual_text_column = 1

    vim.keymap.set("n", "<leader>gbu", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git blame" })
    vim.keymap.set("n", "<leader>gbe", "<cmd>GitBlameEnable<cr>", { desc = "Enable git blame" })
    vim.keymap.set("n", "<leader>gbd", "<cmd>GitBlameDisable<cr>", { desc = "Disable git blame" })
    vim.keymap.set("n", "<leader>gbh", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy commit SHA" })
    vim.keymap.set("n", "<leader>gbl", "<cmd>GitBlameCopyCommitURL<cr>", { desc = "Copy commit URL" })
    vim.keymap.set("n", "<leader>gbo", "<cmd>GitBlameOpenFileURL<cr>", { desc = "Open file in browser" })
    vim.keymap.set("n", "<leader>gbc", "<cmd>GitBlameCopyFileURL<cr>", { desc = "Copy file URL" })
  end,
}
