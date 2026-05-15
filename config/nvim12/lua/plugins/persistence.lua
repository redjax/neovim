-- Persistence https://github.com/folke/persistence.nvim

return {
  src = "https://github.com/folke/persistence.nvim",
  name = "persistence.nvim",

  setup = function()
    local opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
      pre_save = nil,
    }
    require("persistence").setup(opts)

    vim.keymap.set("n", "<leader>qs", function()
      require("persistence").load()
    end, { desc = "Restore Session" })
    vim.keymap.set("n", "<leader>ql", function()
      require("persistence").load({ last = true })
    end, { desc = "Restore Last Session" })
    vim.keymap.set("n", "<leader>qd", function()
      require("persistence").stop()
    end, { desc = "Don't Save Current Session" })
  end,
}
