return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep"
    },
    keys = {
        -- add a keymap to browse plugin files
        -- stylua: ignore
        {
            "<leader>fp",
            function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
            desc = "Find Plugin File",
        },
        {
            '<C-p>',
            function() require("telescope.builtin").git_files() end,
            desc = "Git Files"
        },
        {
            '<leader>ps',
            function() require("telescope.builtin").live_grep() end,
            desc = "Live Grep"
        },
        {
            '<leader>pws',
            function()
                local word = vim.fn.expand("<cword>")
                require("telescope.builtin").grep_string({ search = word })
            end,
            desc = "Grep Word"
        },
        {
            '<leader>pWs',
            function()
                local word = vim.fn.expand("<cWORD>")
                require("telescope.builtin").grep_string({ search = word })
            end,
            desc = "Grep WORD"
        },
        {
            '<leader>vh',
            function() require("telescope.builtin").help_tags() end,
            desc = "Help Tags"
        },
    },

    -- change some options
    opts = {
        defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        },
    },
}