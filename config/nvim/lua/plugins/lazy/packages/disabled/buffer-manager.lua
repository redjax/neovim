-- Buffer Manager https://github.com/j-morano/buffer_manager.nvim

return {
    "j-morano/buffer_manager.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- "VeryLazy" or "BufReadPost" if you want it to load on file open
    event = "VeryLazy",
    config = function()
      require("buffer_manager").setup({
        -- Only show filename (not full path)
        short_file_names = true,
        -- Shorten terminal buffer names
        short_term_names = true,
        -- Wrap navigation at buffer list ends
        loop_nav = true,
        -- Show depth in filename
        show_depth = true,

        select_menu_item_commands = {
          v = { key = "<C-v>", command = "vsplit" },
          h = { key = "<C-h>", command = "split" },
        },
      })
  
      local bm_ui = require("buffer_manager.ui")
      local opts = { noremap = true, silent = true }
  
      -- Keymaps for buffer_manager
      vim.keymap.set({ "n", "t" }, "<Space>bm", bm_ui.toggle_quick_menu, opts)
      vim.keymap.set({ "n", "t" }, "<M-m>", function()
        bm_ui.toggle_quick_menu()
        vim.defer_fn(function() vim.fn.feedkeys("/") end, 50)
      end, opts) -- Alt+m: open menu and start search
  
      vim.keymap.set("n", "<M-j>", bm_ui.nav_next, opts) -- Alt+j: next buffer
      vim.keymap.set("n", "<M-k>", bm_ui.nav_prev, opts) -- Alt+k: previous buffer
  
      -- Optional: number keys to jump to buffer
      local keys = "1234567890"
      for i = 1, #keys do
        local key = keys:sub(i, i)
        vim.keymap.set("n", "<leader>" .. key, function()
          bm_ui.nav_file(i)
        end, opts)
      end
    end,
  }
  