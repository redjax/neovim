-- Garbage collection for LSPs https://github.com/zeioth/garbage-day.vim

return {
  src = "https://github.com/zeioth/garbage-day.nvim",
  name = "garbage-day.nvim",

  setup = function()
    local opts = {
      aggressive_mode = false,          -- stop all LSP clients except current buffer
      excluded_lsp_clients = {},        -- e.g., null-ls, jdtls, marksman, lua_ls
      grace_period = 60 * 15,           -- 15 minutes
      wakeup_delay = 0,                 -- ms to wait before restoring LSP after mouse re-enters Neovim
      notifications = false,
      retries = 3,                      -- times to try to start an LSP client before giving up
      timeout = 1000,                   -- ms to wait during retries to complete
    }

    require("garbage-day").setup(opts)
  end,
}
