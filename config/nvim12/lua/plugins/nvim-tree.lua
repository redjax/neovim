-- NvimTree file explorer with devicons https://github.com/nvim-tree/nvim-tree.lua

return {
  src = "https://github.com/nvim-tree/nvim-tree.lua",

  setup = function()
    -- Disable netrw (required for nvim-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    
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

    -- Global toggle mapping so it works before the first tree open.
    vim.keymap.set("n", "<leader>e", function()
      require("nvim-tree.api").tree.toggle()
    end, { desc = "Toggle NvimTree", noremap = true, silent = true })
    
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
  end,
}
