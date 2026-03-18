return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  keys = {
    { "<leader>gs", ":Git<CR>", desc = "Git status (Fugitive)" },
    { "<leader>gd", ":Gdiffsplit<CR>", desc = "Git diff (Fugitive)" },
    { "<leader>gD", ":Gvdiffsplit<CR>", desc = "3-way diff (Fugitive)" },
    { "<leader>gb", ":Git blame<CR>", desc = "Git blame (Fugitive)" },
    { "<leader>gl", ":Git log --oneline -- %<CR>", desc = "Git log for file" },
    { "<leader>gc", ":Git commit<CR>", desc = "Git commit" },
    { "<leader>gp", ":Git push<CR>", desc = "Git push" },
    { "<leader>gP", ":Git pull<CR>", desc = "Git pull" },
    { "<leader>gr", ":Gread<CR>", desc = "Git checkout file (reset changes)" },
    { "<leader>gw", ":Gwrite<CR>", desc = "Git add (stage) file" },
    { "<leader>gL", ":Gclog<CR>", desc = "Git commit log (quickfix)" },
    { "<leader>gB", ":GBrowse<CR>", desc = "Open in browser (GitHub/GitLab)" },
    { "<leader>ge", ":Gedit<CR>", desc = "Edit file in working tree" },
  },
}
