-- Precognition https://github.com/tris203/precognition.nvim

return {
    "tris203/precognition.nvim",
    -- "VeryLazy" or "BufReadPre" if you want it even earlier
    event = "VeryLazy",
    opts = {
      -- -- Show hints on startup
      -- startVisible = true,
      -- -- Show blank virtual lines if no hint
      -- showBlankVirtLine = true,
      -- -- Use Comment highlight for hints
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --   Caret = { text = "^", prio = 2 },
      --   Dollar = { text = "$", prio = 1 },
      --   MatchingPair = { text = "%", prio = 5 },
      --   Zero = { text = "0", prio = 1 },
      --   w = { text = "w", prio = 10 },
      --   b = { text = "b", prio = 9 },
      --   e = { text = "e", prio = 8 },
      --   W = { text = "W", prio = 7 },
      --   B = { text = "B", prio = 6 },
      --   E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --   G = { text = "G", prio = 10 },
      --   gg = { text = "gg", prio = 9 },
      --   PrevParagraph = { text = "{", prio = 8 },
      --   NextParagraph = { text = "}", prio = 8 },
      -- },
      -- -- Disable on these filetypes
      -- disabled_fts = { "startify", "dashboard" },
    },
    -- lazy-loads on :Precognition command
    cmd = { "Precognition" },
    keys = {
      { "<leader>Pp", function()
          local state = require("precognition").toggle()
          if state then
            vim.notify("Precognition ON")
          else
            vim.notify("Precognition OFF")
          end
        end, desc = "Toggle Precognition" },
      { "<leader>PP", function()
          require("precognition").peek()
        end, desc = "Peek Precognition" },
    },
}
  