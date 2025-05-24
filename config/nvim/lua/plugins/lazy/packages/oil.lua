-- Oil https://github.com/stevearc/oil.nvim

return {
    enabled = true,
    "stevearc/oil.nvim",
    lazy = false, -- Recommended: load on startup for best integration
    dependencies = {
        -- Optional: for file icons
        "nvim-tree/nvim-web-devicons",
        -- or use "echasnovski/mini.icons" if you prefer
    },
    config = function()
        require("oil").setup({
            -- Run :h oil-configuration to see all options

            -- Set as default file explorer, i.e. the :e menu or opening nvim in a directory
            default_file_explorer = true,
            -- Send to trash instead of permanent deletion
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            -- Prompt to save before switching to new file
            prompt_save_on_select_new_entry = true,
            -- Highlight filenames
            highlight_filename = true,
            -- Data columns to show in the explorer
            -- \ Options: icon, type, permissions, owner, size, birthtime, ctime, atime, mtime
            columns = { "icon", "type", "permissions", "owner", "size", "birthtime", "ctime", "atime", "mtime" },
            view_options = {
                -- Show hidden files
                show_hidden = true,
                -- Ignore case in search
                case_insensitive = false,
            },

            -- Float oil window
            float = {
                border = "rounded",
                width = 50,
                height = 30,
                preview_split = "auto",
                win_options = {
                    winblend = 10,
                },
            },

            -- When false, does not set default keybinds. Only the keys you bind explicitly will be active
            use_default_keymaps = true,
        })

        -- Optional: vinegar-style keymap to open Oil in parent directory
        -- \ Only uncomment one of the 2 keymaps below, the 2nd is for a floating window
        -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
        vim.keymap.set("n", "-", function() require("oil").open_float() end, { desc = "Open Oil (float)" })
    end,
}
