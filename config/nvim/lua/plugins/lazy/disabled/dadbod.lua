-- Vim-dadbod/vim-dadbod-ui (database workbench)
-- \ https://github.com/tpope/vim-dadbod
-- \ https://github.com/kristijanhusak/vim-dadbod-ui

return {
    -- Main DB plugin
    {
      "tpope/vim-dadbod",
      lazy = true,
      cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    },
    -- UI for Dadbod
    {
      enabled = true,
      "kristijanhusak/vim-dadbod-ui",
      lazy = true,
      dependencies = {
        "tpope/vim-dadbod",
        -- Optional: completion support
        "kristijanhusak/vim-dadbod-completion",
      },
      cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
      keys = {
        { "<leader>du", "<cmd>DBUIToggle<CR>", desc = "Toggle Dadbod UI" },
      },
      config = function()
        -- Optional: Open UI in a floating window
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_win_position = "right"
        vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
      end,
    },
    -- Optional: Completion for Dadbod in SQL buffers
    {
      "kristijanhusak/vim-dadbod-completion",
      ft = { "sql", "mysql", "plsql" },
      dependencies = { "tpope/vim-dadbod" },
      config = function()
        -- If using nvim-cmp, setup source
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "sql", "mysql", "plsql" },
          callback = function()
            require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
          end,
        })
      end,
    },
  }
  