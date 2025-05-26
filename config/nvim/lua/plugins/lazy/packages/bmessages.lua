-- Bmessages https://github.com/ariel-frischer/bmessages.nvim/tree/main

return {
    enabled = false,
    "ariel-frischer/bmessages.nvim",
    -- "VeryLazy" or "BufReadPre" if you want it even earlier
    event = "VeryLazy",
    config = function()
      require("bmessages").setup({})
    end,
  }
  