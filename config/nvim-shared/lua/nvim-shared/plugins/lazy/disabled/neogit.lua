-- Neogit https://github.com/

return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- optional - Diff integration
        "sindrets/diffview.nvim",

        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim",
        -- "ibhagwan/fzf-lua",
        -- "echasnovski/mini.pick",
        -- "folke/snacks.nvim",
    },
}