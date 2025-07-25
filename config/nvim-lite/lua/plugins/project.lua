-- Project manager https://github.com/ahmedkhalf/project.nvim

return {
    enabled = true,
    "ahmedkhalf/project.nvim",
    -- Loads after startup for best performance
    event = "VeryLazy",
    config = function()
        require("project_nvim").setup({
            -- All options are optional, these are the defaults:
            manual_mode = false,
            detection_methods = { "lsp", "pattern" },
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
            ignore_lsp = {},
            exclude_dirs = {},
            show_hidden = false,
            silent_chdir = true,
            scope_chdir = 'global',
            datapath = vim.fn.stdpath("data"),
        })

        -- Optional: integrate with telescope.nvim
        require('telescope').load_extension('projects')
        vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Find Projects" })
    end,
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
}
