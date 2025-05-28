-- Codewindow https://github.com/gorbit99/codewindow.nvim

return {
    enabled = true,
    "gorbit99/codewindow.nvim",
    -- "VeryLazy" or "BufReadPre" if you want it earlier
    event = "VeryLazy",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({
        -- You can customize options here, or leave empty for defaults
        -- auto_enable = true,
        -- exclude_filetypes = { "NvimTree", "neo-tree", "TelescopePrompt" },
        -- minimap_width = 20,
        -- use_lsp = true,
        -- use_treesitter = true,
        -- show_cursor = true,
        -- screen_bounds = "background",
      })
      codewindow.apply_default_keybinds()
       -- codewindow.open_minimap() -- Uncomment to always show minimap on startup
    end,
    keys = {
      -- These are the default keymaps; you can change them if you like
      { "<leader>mm", function() require("codewindow").toggle_minimap() end, desc = "Toggle minimap" },
      { "<leader>mf", function() require("codewindow").toggle_focus() end, desc = "Toggle minimap focus" },
      { "<leader>me", function() require("codewindow").toggle_maximize() end, desc = "Toggle minimap maximize" },
    },
}
  
