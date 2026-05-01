-- Flash https://github.com/folke/flash.nvim

return {
  -- Required: plugin git source URL.
  src = "https://github.com/folke/flash.nvim",
  name = "flash.nvim",
  setup = function()
    local flash = require("flash")

    -- Standard plugin setup
    flash.setup({
      -- Modes: { "search", "replace", "treesitter-search", ... }
      modes = {
        -- Default search mode
        search = {
          -- Highlight search matches
          highlight = {
            background = true,
          },
          -- Show labels on match
          label = {
            -- Auto‑label window border
            after = false,
            before = true,
          },
          -- Optional: label format
          -- labels = "abcdefghijklmnopqrstuvwxyz",
        },
        -- Optional: replace mode
        -- replace = {
        --   enabled = true,
        -- },
      },

      -- Optional: custom jump behavior (e.g. jumping to search results)
      -- jump = {
      --   autojump = true,
      -- },

      -- Optional: Register keymaps automatically (if you skip this, you define them manually below)
      -- Never let Flash steal your default `s`/`S` bindings if you define them manually.
      keys = {}, -- Empty so we control mappings ourselves
    })

    -- Define keybindings (matching typical lazy.nvim usage)
    -- Normal mode: jump forward
    vim.keymap.set("n", "s", function()
      flash.jump({
        search = {
          -- Optional: customize search behavior
        },
      })
    end, { desc = "Flash jump forward" })

    -- Normal mode: jump backward
    vim.keymap.set("n", "S", function()
      flash.jump({
        search = {
          -- Optional: backward search
        },
      })
    end, { desc = "Flash jump backward" })

    -- Visual mode: search in selection
    vim.keymap.set({ "x", "o" }, "s", function()
      flash.treesitter()
    end, { desc = "Flash in selection / visual mode" })

    -- Optional: autocommands for context‑specific behavior
    -- Example: reconfigure Flash only in certain filetypes
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "lua",
    --   callback = function()
    --     flash.setup({
    --       -- Flash config specific to Lua files
    --     })
    --   end,
    -- })

    -- Optional: define commands
    -- vim.api.nvim_create_user_command("FlashSearch", function()
    --   flash.jump({ search })
    -- end, { desc = "Flash search" })
  end,
}
