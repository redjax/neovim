-- LSP Signature https://github.com/ray-x/lsp_signature.nvim

return {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter", -- Loads when you enter insert mode
    opts = {
        -- Mandatory for borders and floating win config
        bind = true,
        handler_opts = {
            -- "rounded", "single", "double", "shadow", "none", or a border table
            border = "rounded"
        },
        -- Show signature in a floating window
        floating_window = true,
        -- Enable virtual text hints
        hint_enable = true,
        -- You can change this emoji!
        hint_prefix = "🐼 ",
        -- Try to place the window above the current line
        floating_window_above_cur_line = true,
    },
}
