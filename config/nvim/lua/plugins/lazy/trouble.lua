-- Trouble https://github.com/folke/trouble.nvim

return {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },
    event = "VeryLazy", -- or "BufReadPost" to load on file open
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- for icons
    config = function()
        require("trouble").setup({
            position = "bottom",
            height = 10,
            icons = true,
            mode = "workspace_diagnostics",
            fold_open = "",
            fold_closed = "",
            group = true,
            padding = true,
            action_keys = {
                close = "q",
                cancel = "<esc>",
                refresh = "r",
                jump = { "<cr>", "<tab>" },
                open_split = { "<c-x>" },
                open_vsplit = { "<c-v>" },
                open_tab = { "<c-t>" },
                jump_close = { "o" },
                toggle_mode = "m",
                toggle_preview = "P",
                hover = "K",
                preview = "p",
                close_folds = { "zM", "zm" },
                open_folds = { "zR", "zr" },
                toggle_fold = { "zA", "za" },
                previous = "k",
                next = "j"
            },
            auto_open = false,
            auto_close = false,
            auto_preview = true,
            auto_fold = false,
            signs = {
                error = "",
                warning = "",
                hint = "",
                information = "",
                other = ""
            },
            use_diagnostic_signs = false,
        })

        -- Keybinds (these must be outside the setup table)
        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
        vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
        vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { desc = "Document Diagnostics" })
        vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { desc = "Quickfix" })
        vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { desc = "Location List" })
        vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>", { desc = "LSP References" })
    end,
}
