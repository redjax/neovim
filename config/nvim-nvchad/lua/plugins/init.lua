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

      -- Add the keymap from the lazy side
      opts.on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts_desc(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr }
        end

        api.config.mappings.default_on_attach(bufnr)

        -- Map Space+e to toggle from inside nvim-tree
        local map = vim.keymap.set
        map("n", "<leader>e", api.tree.toggle, opts_desc("Toggle NvimTree"))
      end

      return opts
    end,
  }
}
