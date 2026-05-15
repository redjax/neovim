-- Kulala HTTP client https://github.com/mistweaverco/kulala.nvim

return {
  -- NOTE: This plugin will not work until treesitter-cli is installed.
  -- src = "https://github.com/mistweaverco/kulala.nvim",
  -- name = "kulala.nvim",

  -- setup = function()
  --   local opts = {
  --     global_keymaps = true,
  --     global_keymaps_prefix = "<leader>R",
  --     kulala_keymaps_prefix = "",
  --   }
  --   require("kulala").setup(opts)

  --   vim.keymap.set("n", "<leader>Rs", "<cmd>SendRequest<CR>", { desc = "Send request (Kulala)" })
  --   vim.keymap.set("n", "<leader>Ra", "<cmd>KulalaAll<CR>", { desc = "Send all requests (Kulala)" })
  --   vim.keymap.set("n", "<leader>Rb", "<cmd>KulalaOpenScratch<CR>", { desc = "Open scratchpad (Kulala)" })
  -- end,
  nil
}
