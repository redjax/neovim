return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },

  -- Add lazydev as a cmp source (NvChad uses nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
  },
}
