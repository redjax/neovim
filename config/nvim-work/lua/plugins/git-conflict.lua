-- Git conflict https://github.com/

return {
    enabled = true,
    "akinsho/git-conflict.nvim",
    version = "*",
    -- This will call require('git-conflict').setup() with defaults
    config = true,
    -- Optional: loads on file open
    event = { "BufReadPost", "BufNewFile" },
    -- Optional: customize options by replacing `config = true` with a config function:
    -- config = function()
    --   require("git-conflict").setup({
    --     default_mappings = true,        -- buffer-local mappings for conflict resolution
    --     default_commands = true,        -- commands like :GitConflictChooseOurs, etc.
    --     disable_diagnostics = false,    -- disable diagnostics in conflicted buffers
    --     list_opener = "copen",          -- command/function to open conflicts list
    --     highlights = {
    --       incoming = "DiffAdd",
    --       current = "DiffText",
    --     },
    --   })
    -- end,
}
