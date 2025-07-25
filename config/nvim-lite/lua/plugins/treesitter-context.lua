-- Treesitter context (shows the current code context at the top of your window) https://github.com/nvim-treesitter/nvim-treesitter-context

return {
    enabled = true,
    "nvim-treesitter/nvim-treesitter-context",
    -- "VeryLazy" or "BufReadPre" if you want it earlier
    event = "VeryLazy",
    opts = {
      -- Enable this plugin (can toggle via commands)
        enable = true,
      -- No limit on context lines (set >0 to limit)
      max_lines = 0,
      -- No minimum window height
      min_window_height = 0,
      -- Show line numbers in context window
      line_numbers = true,
      -- Max lines to show for a single context
      multiline_threshold = 20,
      -- Discard outer context if max_lines is exceeded
      trim_scope = "outer",
      -- Calculate context from cursor position
      mode = "cursor",
      -- No separator line (set to "-" or similar to enable)
      separator = nil,
      -- Z-index of the context window
      zindex = 20,
      -- Custom function to decide buffer attach (optional)
      on_attach = nil,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      -- Optional: Keymap to jump up to context
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { desc = "Go to Treesitter Context", silent = true })
    end,
    cmd = {
      "TSContextEnable",
      "TSContextDisable",
      "TSContextToggle",
    },
  }
  