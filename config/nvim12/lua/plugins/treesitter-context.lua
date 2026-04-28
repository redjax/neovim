-- Treesitter context https://github.com/nvim-treesitter/nvim-treesitter-context

return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
  name = "nvim-treesitter-context",
  setup = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
      on_attach = nil,
    })

    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "Go to Treesitter Context", silent = true })
  end,
}
