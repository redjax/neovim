-- Lazydev https://github.com/folke/lazydev.nvim

return {
    {   
        "folke/lazydev.nvim",
        -- Only load for Lua files (recommended)
        ft = "lua",
        opts = {},
    },
    -- cmp completions
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
        end,
    },
    -- Blink completions
    {
        "saghen/blink.cmp",
        opts = {
            sources = {
                -- add lazydev to your completion providers
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
        },
    }
}