-- CSV file handling with Rainbow CSV plugin
-- Provides syntax highlighting and table operations for CSV files

return {
  {
    "mechatroner/rainbow_csv",
    ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe", "rfc_csv" },
    config = function()
      -- Rainbow CSV configuration
      vim.g.rainbow_csv_max_columns = 100
      vim.g.rainbow_csv_delim_policy = "quoted"
      
      -- Key mappings for CSV operations
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv", "tsv" },
        callback = function()
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>ca", ":RainbowAlign<CR>", 
            vim.tbl_extend("force", opts, { desc = "Align CSV columns" }))
          vim.keymap.set("n", "<leader>cs", ":RainbowShrink<CR>", 
            vim.tbl_extend("force", opts, { desc = "Shrink CSV columns" }))
          vim.keymap.set("n", "<leader>cq", ":RainbowMultiDelim<CR>", 
            vim.tbl_extend("force", opts, { desc = "Query CSV" }))
        end,
      })
    end,
  },
  
  -- Enhanced completion for CSV files
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "mechatroner/rainbow_csv" },
    opts = function(_, opts)
      -- Add CSV-specific completion sources when in CSV files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv", "tsv" },
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "buffer" },
              { name = "path" },
            }),
          })
        end,
      })
    end,
  },
}