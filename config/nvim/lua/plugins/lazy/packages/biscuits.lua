-- Biscuits https://github.com/code-biscuits/nvim-biscuits

return {
    enabled = true,
    "code-biscuits/nvim-biscuits",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- "VeryLazy", or "BufReadPost" if you want it to load on file open
    event = "VeryLazy",
    config = function()
      require("nvim-biscuits").setup({
        -- Show biscuits only when the cursor is inside a block
        show_on_start = true,
        cursor_line_only = true,
        default_config = {
          min_distance = 5,
          prefix_string = " 🍪 ",
          max_length = 40,
        },
        language_config = {
          lua = {
            prefix_string = "  ",
          },
          python = {
            prefix_string = " 🐍 ",
          },
          javascript = {
            prefix_string = "  ",
          },
          typescript = {
            prefix_string = "  ",
          },
          -- Add more per-language customizations if you like!
        },
      })
    end,
}
  