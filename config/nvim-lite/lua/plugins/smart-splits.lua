-- Smart-splits https://github.com/mrjones2014/smart-splits.nvim

return {
    enabled = true,
    "mrjones2014/smart-splits.nvim",
    -- Remove lazy-loading if you want multiplexer integration (recommended)
    event = "VeryLazy",
    -- Only needed if you use Kitty terminal multiplexer
    -- build = "./kitty/install-kittens.bash",
    opts = {
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "NvimTree", "neo-tree", "qf" },
      -- how many columns/lines to resize by default
      default_amount = 3,
      -- "wrap" or 'stop' or 'split'
      at_edge = "wrap",
      move_cursor_same_row = false,
      -- set to "tmux", "wezterm", "kitty", "zellij", or nil for auto
      multiplexer_integration = nil,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
  
      -- Resizing splits with Alt + hjkl
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left, { desc = "Resize split left" })
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down, { desc = "Resize split down" })
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up, { desc = "Resize split up" })
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right, { desc = "Resize split right" })
  
      -- Moving between splits with Ctrl + hjkl
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left split" })
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to below split" })
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to above split" })
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right split" })
      vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous, { desc = "Move to previous split" })
  
      -- Swapping buffers between windows with <leader><leader> + hjkl
      vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left, { desc = "Swap buffer left" })
      vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down, { desc = "Swap buffer down" })
      vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up, { desc = "Swap buffer up" })
      vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right, { desc = "Swap buffer right" })
    end,
}
  