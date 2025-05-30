-- Nvim-cmp completions https://github.com/hrsh7th/nvim-cmp

return {
    enabled = true,
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- Completion sources
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",

        -- Snippet engine & sources
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",

        -- VS Code-like pictograms
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- Load friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Recommended completion options
        vim.opt.completeopt = { "menu", "menuone", "noselect" }

        cmp.setup({
        snippet = {
            expand = function(args)
            luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            -- Set <Tab> fallback so when cmp window is not showing,
            -- \ <Tab> functions normally
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    -- Explicitly insert a tab character (which will be spaces if expandtab is set)
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
                        "n",
                        true
                    )
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    -- Explicitly insert a Shift-Tab (if you want, or just fallback)
                    fallback()
                end
            end, { "i", "s" }),
            -- Set <S-Tab> fallback so when cmp window is not showing,
            -- \ <S-Tab> dedents text
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    -- Explicitly dedent
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<C-d>", true, true, true),
                        "n",
                        true
                    )
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        }),
        formatting = {
            format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            }),
        },
        experimental = {
            ghost_text = true,
        },
        })

        -- Cmdline completions
        cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" }
        }
        })

        cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" }
        }, {
            { name = "cmdline" }
        })
        })

        -- Only uncomment below if you do not use a separate LSP setup file.
        -- \ If you handle all of your server setup in this cmp.lua, you can uncomment this

        -- LSP capabilities integration (for all servers)
        -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
        -- If you use nvim-lspconfig, add this to your LSP setup:
        -- require("lspconfig")[SERVER].setup({ capabilities = capabilities })
        -- Or, for all servers:
        -- local lspconfig = require("lspconfig")
        -- for _, server in ipairs(vim.tbl_keys(lspconfig.servers)) do
        --     lspconfig[server].setup({ capabilities = capabilities })
        -- end
    end,
}
