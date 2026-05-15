-- Telescope undo https://github.com/debugloop/telescope-undo.nvim

return {
  src = "https://github.com/debugloop/telescope-undo.nvim",
  name = "telescope-undo.nvim",
  setup = function()
    require("telescope").setup({
      extensions = {
        undo = {},
      },
    })

    require("telescope").load_extension("undo")

    vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "undo history" })
  end,
}
