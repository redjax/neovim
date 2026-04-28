-- Output panel https://github.com/mhanberg/output-panel.nvim

return {
  src = "https://github.com/mhanberg/output-panel.nvim",
  name = "output-panel.nvim",
  version = "main",

  setup = function()
    require("output_panel").setup({
      max_buffer_size = 5000,
    })

    vim.keymap.set(
      "n",
      "<leader>o",
      vim.cmd.OutputPanel,
      { desc = "Toggle the output panel" }
    )
  end,
}
