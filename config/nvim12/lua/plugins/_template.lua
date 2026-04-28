-- Plugin spec template for nvim12 vim.pack manager.
-- Files beginning with "_" are ignored by the plugin loader.

return {
  -- Required: plugin git source URL.
  src = "https://github.com/owner/repo",

  -- Optional: override inferred plugin name (defaults to repository name).
  -- name = "repo",

  -- Optional: semver range, tag, branch, or commit.
  -- version = "main",

  -- Optional: configure plugin after it is loaded via :packadd.
  -- This is handled by lua/plugins/init.lua (not a native vim.pack field).
  -- setup = function(spec)
  --   -- require("plugin").setup({})
  -- end,
}

return {
  -- Required: plugin git source URL.
  src = "https://github.com/owner/repo",

  -- Optional: override inferred plugin name (defaults to repository name).
  -- name = "repo",

  -- Optional: semver range, tag, branch, or commit.
  -- version = "main",

  -- Optional: configuration logic executed after loading.
  setup = function()
    -- Ensure plugin is loaded (especially for lazy-loaded/conditional plugins).
    -- vim.cmd("packadd repo")

    -- Standard plugin setup
    -- require("plugin").setup({})

    -- Define keybindings.
    -- vim.keymap.set("n", "<leader>k", function() ... end, { desc = "Plugin action" })

    -- Define autocommands (e.g., for filetype-specific loading).
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "filetype",
    --   callback = function()
    --     require("plugin").setup({})
    --   end,
    -- })

    -- Define custom commands.
    -- vim.api.nvim_create_user_command("MyCommand", function() ... end, {})
  end,
}