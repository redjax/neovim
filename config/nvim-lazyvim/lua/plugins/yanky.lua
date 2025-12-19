-- Yanky https://github.com/gbprod/yanky.nvim

return {
  "gbprod/yanky.nvim",
  keys = {
    { "p", mode = { "n", "x" } },
    { "P", mode = { "n", "x" } },
    { "<leader>p", desc = "Yank History" },
  },
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    -- You can customize options here, or leave empty for sensible defaults
    -- ring = { history_length = 100, storage = "shada" },
    -- picker = { select = { action = nil } },
    -- highlight = { on_put = true, on_yank = true, timer = 500 },
    -- preserve_cursor_position = { enabled = true },
  },
  config = function(_, opts)
    require("yanky").setup(opts)

    -- Recommended keymaps (see below)
    local map = vim.keymap.set

    -- Register the yank_history extension with Telescope
    pcall(function()
      require("telescope").load_extension("yank_history")
    end)

    -- Cycle through yank history (pasting)
    map({"n","x"}, "p", "<Plug>(YankyPutAfter)", {desc = "Yanky Put After"})
    map({"n","x"}, "P", "<Plug>(YankyPutBefore)", {desc = "Yanky Put Before"})
    map({"n","x"}, "gp", "<Plug>(YankyGPutAfter)", {desc = "Yanky GPut After"})
    map({"n","x"}, "gP", "<Plug>(YankyGPutBefore)", {desc = "Yanky GPut Before"})
    -- Cycle through history
    map("n", "<c-n>", "<Plug>(YankyCycleForward)", {desc = "Yanky Cycle Forward"})
    map("n", "<c-p>", "<Plug>(YankyCycleBackward)", {desc = "Yanky Cycle Backward"})
    -- Telescope integration
    map("n", "<leader>sy", function()

      -- Only require when the keymap is actually used
      require("telescope").extensions.yank_history.yank_history({})
    end, {desc = "Yank History (Telescope)"})
  end,
}

  