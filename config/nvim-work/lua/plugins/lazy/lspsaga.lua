-- LSPSaga - Enhanced LSP UI and navigation
-- https://github.com/nvimdev/lspsaga.nvim

return {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach", -- loads when LSP attaches to a buffer
    dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional but recommended
        "nvim-tree/nvim-web-devicons"      -- optional for icons
    },
    config = function()
        require("lspsaga").setup({
            ui = { 
                border = "rounded",
                title = true,
            },
            symbol_in_winbar = {
                enable = true,
                separator = " › ",
                hide_keyword = true,
                show_file = true,
                folder_level = 2,
            },
            lightbulb = {
                enable = true,
                enable_in_insert = true,
                sign = true,
                sign_priority = 40,
                virtual_text = true,
            },
            diagnostic = {
                show_code_action = true,
                show_source = true,
                jump_num_shortcut = true,
                keys = {
                    exec_action = "o",
                    quit = "q",
                },
            },
            code_action = {
                num_shortcut = true,
                show_server_name = false,
                extend_gitsigns = true,
                keys = {
                    quit = "q",
                    exec = "<CR>",
                },
            },
            finder = {
                max_height = 0.5,
                min_width = 30,
                force_max_height = false,
                keys = {
                    jump_to = "p",
                    expand_or_jump = "o",
                    vsplit = "s",
                    split = "i",
                    tabe = "t",
                    tabnew = "r",
                    quit = { "q", "<ESC>" },
                },
            },
            definition = {
                edit = "<C-c>o",
                vsplit = "<C-c>v",
                split = "<C-c>i",
                tabe = "<C-c>t",
                quit = "q",
            },
            rename = {
                quit = "<C-c>",
                exec = "<CR>",
                mark = "x",
                confirm = "<CR>",
                in_select = true,
            },
            outline = {
                win_position = "right",
                win_with = "",
                win_width = 30,
                show_detail = true,
                auto_preview = true,
                auto_refresh = true,
                auto_close = true,
                custom_sort = nil,
                keys = {
                    jump = "o",
                    expand_collapse = "u",
                    quit = "q",
                },
            },
        })
    end,
}