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
