-- Carbon https://github.com/SidOfc/carbon.nvim

return {
    enabled = false,
    "SidOfc/carbon.nvim",
    -- Optional: for file icons support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Basic setup with defaults
      require("carbon").setup({
        -- Enable devicons support for files/folders
        file_icons = true,
        -- Reveal the current file in the tree when opening Carbon
        auto_reveal = true,
        -- Keep netrw enabled (set to false to hijack :Explore)
        keep_netrw = false,
        -- Sidebar position ("left" or "right")
        sidebar_position = "left",
        -- Floating window settings for :Fcarbon
        float_settings = {
          border = "rounded",
          width = 40,
          height = 20,
          row = 2,
          col = 2,
        },
        -- Sync Carbon's root with Neovim's pwd
        sync_pwd = true,
        -- Change Carbon's root on :cd
        sync_on_cd = true,
        -- Compress nested directories up to this depth
        compress_max_depth = 3,
        -- Highlight symlinks, broken links, and executables
        highlight_special = true,
        -- Show hidden files (dotfiles)
        show_hidden = true,
      })
      
  
      -- Optional: Keymap to open Carbon in the current buffer
      vim.keymap.set("n", "<leader>e", ":Carbon<CR>", { desc = "Open Carbon file explorer" })
      -- Optional: Keymap to toggle Carbon in a floating window
      vim.keymap.set("n", "<leader>fe", ":Fcarbon<CR>", { desc = "Open Carbon (float)" })
    end,
    lazy = false, -- Set to true if you want to lazy-load
}
  