-- Obsidian 

return {
    enabled = false,
    "epwalsh/obsidian.nvim",
    version = "*", -- Use latest release for stability
    ft = "markdown", -- Loads only for markdown files (recommended)
    dependencies = {
        "nvim-lua/plenary.nvim",           -- Required
        "nvim-telescope/telescope.nvim",   -- Recommended for pickers
        "nvim-treesitter/nvim-treesitter", -- Recommended for syntax highlighting
        "hrsh7th/nvim-cmp",                -- Recommended for completion
    },
    opts = {
        workspaces = {
            -- {
            --     name = "personal",
            --     path = "~/vaults/personal",
            -- },
            -- {
            --     name = "work",
            --     path = "~/vaults/work",
            -- },
        },
        -- Optional: see full list of options in the README
        completion = { nvim_cmp = true },
        new_notes_location = "notes_subdir",
        notes_subdir = "notes",
        daily_notes = {
            folder = "notes/dailies",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
            default_tags = { "daily-notes" },
        },
        templates = {
            folder = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
        },
        -- Optional: customize mappings or other settings here
    },
}
