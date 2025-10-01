-- Bmessages https://github.com/ariel-frischer/bmessages.nvim/tree/main

return {
    "ariel-frischer/bmessages.nvim",
    -- "VeryLazy" or "BufReadPre" if you want it even earlier
    event = "VeryLazy",
    config = function()
      require("bmessages").setup({})
    end,
  }
  