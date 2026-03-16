-- Project manager https://github.com/DrKJeff16/project.nvim

return {
    "DrKJeff16/project.nvim",
    event = "VeryLazy",
    config = function()
        require("project").setup({
            manual_mode = false,
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
            exclude_dirs = {},
            show_hidden = false,
            silent_chdir = true,
            scope_chdir = 'global',
            datapath = vim.fn.stdpath("data"),
        })

        require('telescope').load_extension('projects')
        vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Find Projects" })
    end,
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
}
