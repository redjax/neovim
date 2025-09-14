-- Persistence https://github.com/folke/persistence.nvim

return {
    "folke/persistence.nvim",
    -- Start session management before buffers are read
    event = "BufReadPre",
    opts = {
        -- Directory where session files are saved
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        -- Session options
        options = { "buffers", "curdir", "tabpages", "winsize" },
        -- Function to run before saving the session
        pre_save = nil,
    },
    config = function(_, opts)
        require("persistence").setup(opts)

        -- Optional: Keymaps for session management
        vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
        vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
        vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
    end,
}
