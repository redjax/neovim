return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- Ensure opts.sources exists before inserting
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}