-- Oil https://github.com/stevearc/oil.nvim

return {
    "stevearc/oil.nvim",
    lazy = false, -- Recommended: load on startup for best integration
    dependencies = {
        -- Optional: for file icons
        "nvim-tree/nvim-web-devicons",
        -- or use "echasnovski/mini.icons" if you prefer
    },
    config = function()
        require("oil").setup({
            columns = { "icon", "permissions", "size", "mtime" },
            view_options = { show_hidden = true },
        })
        -- Optional: vinegar-style keymap to open Oil in parent directory
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
    end,
}
