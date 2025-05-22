-- Ariel https://github.com/stevearc/aerial.nvim

return {
    enabled = true,
    "stevearc/aerial.nvim",
    opts = {
        -- Prefer Treesitter, then LSP, then fallback for outline
        backends = { "treesitter", "lsp", "markdown", "man" },
        open_automatic = true,
        layout = {
            max_width = { 40, 0.2 },
            min_width = 10,
            default_direction = "prefer_right",
            placement = "window",
            resize_to_content = true,
        },
        attach_mode = "window",
        -- Show all symbol kinds by default
        filter_kind = false,
        -- Show tree guides
        show_guides = true,
        -- Use nerd font icons if available
        nerd_font = "auto",
        -- Set up keymaps when aerial attaches to a buffer
        on_attach = function(bufnr)
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial Prev Symbol" })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial Next Symbol" })
        end,
    },
    dependencies = {
        -- For Treesitter backend (recommended)
        "nvim-treesitter/nvim-treesitter",
        -- For filetype icons (optional, recommended)
        "nvim-tree/nvim-web-devicons",
    },
    -- Optional: lazy-load aerial only when you call a command
    cmd = { "AerialToggle", "AerialOpen", "AerialOpenAll", "AerialClose", "AerialCloseAll", "AerialNavToggle", "AerialNavOpen", "AerialNavClose" },
    -- Optional: open automatically for certain filetypes
    -- event = "LspAttach",

    config = function(_, opts)
        require("aerial").setup(opts)
        -- Global keymap to toggle aerial
        vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Aerial (Outline) Toggle" })
        -- Optional: Open Aerial automatically when entering supported buffers
        -- vim.api.nvim_create_autocmd("FileType", {
        --   pattern = { "python", "lua", "javascript", "typescript", "go", "rust", "c", "cpp" },
        --   callback = function() require("aerial").open({ focus = false }) end,
        -- })

        -- Open Aerial for supported filetypes
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "python", "lua", "javascript", "typescript", "go", "rust",
                "c", "cpp", "markdown", "java", "html", "json", "yaml", "toml"
            },
            callback = function()
                require("aerial").open({ focus = false })
            end,
        })
    end,
}
