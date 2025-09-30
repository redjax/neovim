return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { 
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "f3fora/cmp-spell",
      "ray-x/cmp-treesitter",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      
      -- Ensure opts.sources exists before inserting
      opts.sources = opts.sources or {}
      
      -- Add additional completion sources
      vim.list_extend(opts.sources, {
        { name = "emoji" },
        { name = "path" },
        { name = "treesitter", group_index = 2 },
        { name = "spell", group_index = 2 },
      })
      
      -- Enhanced sorting
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
      
      -- File type specific configurations
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "yaml", "yml" },
        callback = function()
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "buffer" },
              { name = "path" },
              { name = "spell" },
            }),
          })
        end,
      })
      
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "terraform", "tf" },
        callback = function()
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "buffer" },
              { name = "path" },
            }),
          })
        end,
      })
      
      return opts
    end,
  },
}