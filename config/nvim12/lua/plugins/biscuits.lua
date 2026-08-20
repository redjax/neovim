-- Biscuits https://github.com/code-biscuits/nvim-biscuits

return {
    src = "https://github.com/code-biscuits/nvim-biscuits",
    name = "nvim-biscuits",
    version = "main",
    setup = function()
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