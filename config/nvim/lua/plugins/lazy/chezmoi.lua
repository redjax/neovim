-- Cheezmoi integration https://github.com/xvzc/chezmoi.nvim

return {
  "xvzc/chezmoi.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- Load conditionally, if chezmoi is found in $PATH
  cond = function()
    return vim.fn.executable("chezmoi") == 1
  end,
  config = function()
    require("chezmoi").setup {
        edit = {
            -- Set to true to watch files and auto-apply on save
            watch = false,
            -- Set to true to force editing even if file is unchanged
            force = false,
    },
    events = {
        on_open = {
        notification = {
            enable = true,
            msg = "Opened a chezmoi-managed file",
            -- Additional notification options (see :h vim.notify)
            opts = {}, 
        },
        },
        on_watch = {
        notification = {
            enable = true,
            msg = "This file will be automatically applied",
            opts = {},
        },
        },
        on_apply = {
        notification = {
            enable = true,
            msg = "Successfully applied",
            opts = {},
        },
        },
    },
    telescope = {
        -- Keymap for selecting files with Telescope (if using)
        select = { "<CR>" },
    },
    }
  end,
}