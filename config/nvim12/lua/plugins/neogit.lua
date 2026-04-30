-- Neogit - Git interface for Neovim https://github.com/NeogitOrg/neogit

return {
  src = "https://github.com/NeogitOrg/neogit",
  name = "neogit",
  version = "master",

  setup = function()
    -- Neogit requires plenary to be loaded first
    require("plenary")
    
    require("neogit").setup({
      -- Automatically display status after operations
      auto_show_console = true,

      -- Kind of split to open, can be "split", "vsplit", "split_above", "vsplit_right",
      -- "tab", "replace", "belowright", "aboveleft", "rightbelow", "leftabove"
      kind = "vsplit",

      -- Width of the split window (for vsplit)
      -- Can be a number or function that returns number
      width = 120,

      -- Commands that should be disabled in the neogit panel
      disable_commands = {},

      -- When true, commit author and email are fetched from git config
      -- Set to false if you want to enter them manually every time
      use_magit_keybindings = true,

      -- Disables signs in the status buffer
      disable_signs = false,

      -- Configure the notification system
      notification_level = "info", -- "trace", "debug", "info", "warn", "error"

      -- Configure the graphql query used for the log view
      -- Leave blank or nil to use the default
      graph_style = "unicode",

      -- Configure the git notifications
      git = {
        -- Whether to use git --no-optional-locks
        ignore_locks = false,
      },

      -- Configure the symbols used in the interface
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { ">", "v" },
      },

      -- Configure telescope integration
      telescope_nvim = true,

      -- Configure diffview.nvim integration
      integrations = {
        diffview = true,
        telescope = true,
      },

      -- Show the commit hash in the diff view
      -- Useful for referencing commits
      commit_editor = {
        kind = "auto",
        -- Size for floating window
        -- Can be a number or function that returns number
        width = 140,
        height = 40,
      },

      -- Configure popup windows
      popup = {
        kind = "split",
      },

      -- Keep hjkl navigation while preserving a key for log popup in Magit mode.
      mappings = {
        popup = {
          ["l"] = false,
          ["L"] = "LogPopup",
        },
      },

      -- Configure which branch to checkout after creating/rebasing
      -- Useful when you want to automatically switch branches
      auto_refresh = true,

      -- Refresh git status in the background
      -- When true, neogit will update status info periodically
      refresh_after_rescan = true,
    })

    -- Keymaps for neogit operations
    -- Main entry point: toggle neogit status
    vim.keymap.set("n", "<leader>gs", function()
      require("neogit").open()
    end, { desc = "Neogit status" })

    -- Common operations
    vim.keymap.set("n", "<leader>gc", function()
      require("neogit").open({ "commit" })
    end, { desc = "Neogit commit" })

    vim.keymap.set("n", "<leader>gp", function()
      require("neogit").open({ "push" })
    end, { desc = "Neogit push" })

    vim.keymap.set("n", "<leader>gl", function()
      require("neogit").open({ "log" })
    end, { desc = "Neogit log" })

    vim.keymap.set("n", "<leader>gB", function()
      require("neogit").open({ "branch" })
    end, { desc = "Neogit branches" })

    vim.keymap.set("n", "<leader>gR", function()
      require("neogit").open({ "rebase" })
    end, { desc = "Neogit rebase" })

    vim.keymap.set("n", "<leader>gM", function()
      require("neogit").open({ "merge" })
    end, { desc = "Neogit merge" })

    vim.keymap.set("n", "<leader>gP", function()
      require("neogit").open({ "pull" })
    end, { desc = "Neogit pull" })

    vim.keymap.set("n", "<leader>gS", function()
      require("neogit").open({ "stash" })
    end, { desc = "Neogit stash" })

    -- Custom command aliases for quick access
    vim.api.nvim_create_user_command("Npush", function()
      require("neogit").open({ "push" })
    end, {})

    vim.api.nvim_create_user_command("Npull", function()
      require("neogit").open({ "pull" })
    end, {})

    vim.api.nvim_create_user_command("NeogitStash", function()
      require("neogit").open({ "stash" })
    end, {})
  end,
}
