-- None-ls https://github.com/nvimtools/none-ls.nvim

return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
        sources = {
            -- Formatters
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.prettier,
            -- Linters
            null_ls.builtins.diagnostics.eslint,
            -- Code actions
            null_ls.builtins.code_actions.gitsigns,
        }
        })
    end,
}
