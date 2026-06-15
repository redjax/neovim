-- NvimTree file explorer with devicons https://github.com/nvim-tree/nvim-tree.lua

return {
  src = "https://github.com/nvim-tree/nvim-tree.lua",
  cmd = {
    "NvimTreeToggle",
    "NvimTreeOpen",
    "NvimTreeFocus",
    "NvimTreeFindFile",
  },
  lazy = true,

  setup = function()
    if vim.g.nvim_tree_setup_done then
      return
    end

    -- Enable 24-bit colors (required for icons)
    vim.opt.termguicolors = true
    
    local api = require("nvim-tree.api")
    
    local function opts_desc(desc)
      return {
        desc = "nvim-tree: " .. desc,
        noremap = true,
        silent = true,
        nowait = true,
      }
    end
    
    local function on_attach(bufnr)
      -- Default mappings first
      api.config.mappings.default_on_attach(bufnr)

      -- Buffer-local extra mapping from inside nvim-tree
      vim.keymap.set("n", "<leader>e", api.tree.toggle, vim.tbl_extend("force", opts_desc("Toggle NvimTree"), { buffer = bufnr }))
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      
      -- Auto-close tree when file opened
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      
      -- Common NvChad-like settings
      view = {
        width = 30,
        side = "left",
        preserve_window_proportions = true,
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      git = {
        enable = true,
        ignore = false,
      },
    })

    vim.g.nvim_tree_setup_done = true
  end,
}
