-- Hardtime (break bad habits, master vim shortcuts) https://github.com/m4xshen/hardtime.nvim

return {
    enabled = false,
    "m4xshen/hardtime.nvim",
    -- "VeryLazy" or "BufReadPre" if you want it even earlier
    event = "VeryLazy",
    opts = {
      -- Enable hardtime by default
      enabled = true,
      -- Number of allowed repeated keys before warning
      max_count = 3,
      -- Set true to disable mouse
      disable_mouse = false,
      -- Show notifications when hardtime triggers
      notification = true,
      -- restriction_mode = "hint", -- "hint", "block", or "none"
      -- hints = {},           -- Custom hints (see README)
      -- disabled_keys = {},   -- List of keys to ignore
      -- disabled_filetypes = { "NvimTree", "neo-tree", "lazy" }, -- Filetypes to ignore
      -- ... see README for more options
    },
    config = function(_, opts)
      require("hardtime").setup(opts)
    end,
    cmd = {
      "HardtimeEnable",
      "HardtimeDisable",
      "HardtimeToggle",
    },
}