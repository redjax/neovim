-- Navic https://github.com/SmiteshP/nvim-navic

return {
    enabled = true,
    "SmiteshP/nvim-navic",
    -- Required for LSP integration
    dependencies = { "neovim/nvim-lspconfig" },
    -- Load when LSP attaches
    event = "LspAttach",
    opts = {
        -- Automatically attach to all LSPs that support documentSymbol
        lsp = {
            auto_attach = true,
            -- Prefer yamlls over other LSPs like
            -- \ Azure pipelines or Github Actions
            preference = { "yamlls" },
        },
        -- Enable highlighting for breadcrumbs
        highlight = true,
        -- Breadcrumb separator
        separator = " > ",
        -- No depth limit
        depth_limit = 0,
        -- Shown if depth limit is hit
        depth_limit_indicator = "..",
    },
    config = function(_, opts)
        local navic = require("nvim-navic")
        navic.setup(opts)

        -- Optional: Show breadcrumbs in the winbar
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.server_capabilities.documentSymbolProvider then
                navic.attach(client, args.buf)
                vim.api.nvim_set_option_value(
                    "winbar",
                    "%{%v:lua.require'nvim-navic'.get_location()%}",
                    { scope = "local", win = 0 }
                )
                end
            end,
        })
    end,
}
