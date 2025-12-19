-- Garbage collection for LSPs https://github.com/zeioth/garbage-day.vim

return {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "LspAttach",
    opts = {
        aggressive_mode = false, -- Stop all LSP clients except current buffer
        excluded_lsp_clients = {}, -- null-ls, jdtls, marksman, lua_ls
        grace_period = 60*15, -- 15 minutes
        wakeup_delay = 0, -- ms to wait before restoring LSP after mouse re-enters neovim
        notifications = false,
        retries = 3, -- Times to try to start an LSP client before giving up
        timeout = 1000 -- ms to wait during retries to complete
    }
}
