-- Fugitive git client https://github.com/tpope/vim-fugitive

return {
    enabled = true,
    "tpope/vim-fugitive",
    -- Default: "VeryLazy". "BufReadPre" if you want it loaded earlier
    event = "VeryLazy",

    -- Fugitive keybinds
    config = function()
        vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status (Fugitive)" })
        vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff (Fugitive)" })
        vim.keymap.set("n", "<leader>gD", ":Gvdiffsplit<CR>", { desc = "3-way diff (Fugitive)" })
        vim.keymap.set("n", "<leader>gb", ":Gblame<CR>", { desc = "Git blame (Fugitive)" })
        vim.keymap.set("n", "<leader>gl", ":Git log --oneline -- %<CR>", { desc = "Git log for file" })
        vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
        vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
        vim.keymap.set("n", "<leader>gP", ":Git pull<CR>", { desc = "Git pull" })
        vim.keymap.set("n", "<leader>gr", ":Gread<CR>", { desc = "Git checkout file (reset changes)" })
        vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>", { desc = "Git add (stage) file" })
        vim.keymap.set("n", "<leader>gL", ":Gclog<CR>", { desc = "Git commit log (quickfix)" })
        vim.keymap.set("n", "<leader>gB", ":GBrowse<CR>", { desc = "Open in browser (GitHub/GitLab)" })
        vim.keymap.set("n", "<leader>ge", ":Gedit<CR>", { desc = "Edit file in working tree" })
    end,
}
