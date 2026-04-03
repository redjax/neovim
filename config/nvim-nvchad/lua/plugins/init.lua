-- NvChad loads all *.lua plugins in the lua/plugins/ directory. Each plugin has its own file
-- to make it easier to manage. Any plugins in the lua/plugins/disabled/ directory will be skipped.
return {
  {
  "nvim-tree/nvim-tree.lua",
  opts = function()
      local opts = require "nvchad.configs.nvimtree"
      opts.actions = opts.actions or {}
      opts.actions.open_file = opts.actions.open_file or {}
      opts.actions.open_file.quit_on_open = true
      return opts
    end,
  }
}
