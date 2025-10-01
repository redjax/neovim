-- Triptych https://github.com/simonmclean/triptych.nvim

return {
    -- Main plugin repository
    "simonmclean/triptych.nvim",
    lazy = true,
    -- Load Triptych when <leader>- is pressed (you can change this if you like)
    keys = {
      { "<leader>e", ":Triptych<CR>", desc = "Open Triptych" },
    },
    -- Required and optional dependencies
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      -- Optional: LSP file ops
      -- "antosha417/nvim-lsp-file-operations",
    },
    opts = {
      -- Key mappings for Triptych window (buffer-local)
      mappings = {
        -- Show help popup
        show_help = "g?",
        -- Jump to current working directory (toggle with repeated press)
        jump_to_cwd = ".",
        -- Navigate to parent directory (left window)
        nav_left = "h",
        -- Navigate to child directory or open file (right window)
        nav_right = { "l", "<CR>" },
        -- Open file in horizontal split
        open_hsplit = { "-" },
        -- Open file in vertical split
        open_vsplit = { "|" },
        -- Open file in new tab
        open_tab = { "<C-t>" },
        -- Change directory to selected
        cd = "<leader>cd",
        -- Delete file or directory (bulk delete in visual mode)
        delete = "d",
        -- Add new file or directory
        add = "a",
        -- Copy file or directory (bulk copy in visual mode)
        copy = "c",
        -- Rename file or directory (bulk rename in visual mode)
        rename = "r",
        -- Cut file or directory (bulk cut in visual mode)
        cut = "x",
        -- Paste file or directory (bulk paste in visual mode)
        paste = "p",
        -- Quit Triptych
        quit = "q",
        -- Toggle hidden files
        toggle_hidden = "<leader>.",
        -- Toggle collapsed directories
        toggle_collapse_dirs = "z",
      },
  
      -- Extension mappings for custom actions
      extension_mappings = {
        -- Example: Telescope live_grep on <c-f>
        -- ["<c-f>"] = {
        --   mode = "n",
        --   fn = function(target, _)
        --     require 'telescope.builtin'.live_grep { search_dirs = { target.path } }
        --   end
        -- }
      },
  
      options = {
        -- List directories before files
        dirs_first = true,
        -- Show hidden files by default
        show_hidden = false,
        -- Collapse nested directories
        collapse_dirs = true,
        -- Line numbers in Triptych windows
        line_numbers = {
          enabled = true,
          relative = false,
        },
        -- File icons settings
        file_icons = {
          enabled = true,
          directory_icon = "",      -- Set to a glyph if you want
          fallback_file_icon = "",  -- Set to a glyph if you want
        },
        -- Responsive column widths (based on vim.o.columns)
        responsive_column_widths = {
          -- When columns >= 0: [parent, current, child] window widths
          ["0"]   = { 0, 0.5, 0.5 },
          -- When columns >= 120
          ["120"] = { 0.2, 0.3, 0.5 },
          -- When columns >= 200
          ["200"] = { 0.25, 0.25, 0.5 },
        },
        -- Highlight groups for file and directory names
        highlights = {
          file_names = "NONE",
          directory_names = "NONE",
        },
        -- Syntax highlighting for file previews
        syntax_highlighting = {
          enabled = true,
          debounce_ms = 100,
        },
        -- Backdrop opacity (0 = opaque, 100 = transparent/disabled)
        backdrop = 60,
        -- Window transparency (0 = opaque, 100 = transparent)
        transparency = 0,
        -- Border style for floating windows
        border = "single",
        -- Maximum floating window height
        max_height = 45,
        -- Maximum floating window width
        max_width = 220,
        -- Horizontal margin (columns)
        margin_x = 4,
        -- Vertical margin (lines)
        margin_y = 4,
      },
  
      -- Git integration
      git_signs = {
        enabled = true,
        signs = {
          add = "+",
          modify = "~",
          rename = "r",
          untracked = "?",
        },
      },
  
      -- Diagnostic (LSP) integration
      diagnostic_signs = {
        enabled = true,
      },
    },
}
  