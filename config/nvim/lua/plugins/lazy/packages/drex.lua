-- Drex https://github.com/TheBlob42/drex.nvim

return {
    enabled = true,
    "TheBlob42/drex.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require('drex.config').configure {
        -- Icons for files, directories, links, and others
        icons = {
          -- Icon for files without a specific icon
          file_default = "", -- nf-fa-file
          -- Icon for open directories
          dir_open = "", -- nf-fa-folder_open
          -- Icon for closed directories
          dir_closed = "", -- nf-fa-folder
          -- Icon for symlinks
          link = "", -- nf-oct-file_symlink_file
          -- Icon for other types
          others = "" -- nf-fa-file_text
        },
  
        -- Use colored icons if devicons are enabled
        colored_icons = true,
  
        -- Hide the cursor in the drex buffer
        hide_cursor = true,
  
        -- Hijack netrw to open drex instead
        hijack_netrw = false,
  
        -- Keep the alternate file (affects file opening behavior)
        keepalt = false,
  
        -- Sorting function for directory entries
        -- \ By default, directories are listed before files, then sorted alphabetically
        sorting = function(a, b)
          local aname, atype = a[1], a[2]
          local bname, btype = b[1], b[2]
          local aisdir = atype == 'directory'
          local bisdir = btype == 'directory'
          if aisdir ~= bisdir then return aisdir end
          return aname < bname
        end,
  
        -- Project drawer configuration
        drawer = {
          -- Side of the drawer ("left" or "right")
          side = 'left',
          -- Default width of the drawer window
          default_width = 30,
          -- Window picker for opening files
          window_picker = {
            -- Enable window picker
            enabled = true,
            -- Labels used for window picking
            labels = 'abcdefghijklmnopqrstuvwxyz',
          },
        },
  
        -- File action configuration
        actions = {
          files = {
            -- Custom delete command (nil uses default)
            delete_cmd = nil,
          },
        },
  
        -- Disable all default keybindings (set to true to disable)
        disable_default_keybindings = false,
  
        -- Keybindings for normal and visual mode
        keybindings = {
          -- Normal mode keybindings
          n = {
            -- Use 'V' for visual mode (no charwise selection)
            v = 'V',
            -- Expand the current element (directory or file)
            l = { '<cmd>lua require("drex.elements").expand_element()<CR>', { desc = 'expand element' }},
            -- Collapse the current directory's subtree
            h = { '<cmd>lua require("drex.elements").collapse_directory()<CR>', { desc = 'collapse directory' }},
            -- Expand element (alternative: right arrow)
            ["<right>"] = { '<cmd>lua require("drex.elements").expand_element()<CR>', { desc = 'expand element' }},
            -- Collapse directory (alternative: left arrow)
            ["<left>"] = { '<cmd>lua require("drex.elements").collapse_directory()<CR>', { desc = 'collapse directory' }},
            -- Expand element (alternative: double left mouse)
            ["<2-LeftMouse>"] = { '<LeftMouse><cmd>lua require("drex.elements").expand_element()<CR>', { desc = 'expand element' }},
            -- Collapse directory (alternative: right mouse)
            ["<RightMouse>"] = { '<LeftMouse><cmd>lua require("drex.elements").collapse_directory()<CR>', { desc = 'collapse directory' }},
            -- Open file in vertical split
            ["<C-v>"] = { '<cmd>lua require("drex.elements").open_file("vs")<CR>', { desc = 'open file in vsplit' }},
            -- Open file in horizontal split
            ["<C-x>"] = { '<cmd>lua require("drex.elements").open_file("sp")<CR>', { desc = 'open file in split' }},
            -- Open file in new tab
            ["<C-t>"] = { '<cmd>lua require("drex.elements").open_file("tabnew", true)<CR>', { desc = 'open file in new tab' }},
            -- Open directory in new buffer
            ["<C-l>"] = { '<cmd>lua require("drex.elements").open_directory()<CR>', { desc = 'open directory in new buffer' }},
            -- Open parent directory in new buffer
            ["<C-h>"] = { '<cmd>lua require("drex.elements").open_parent_directory()<CR>', { desc = 'open parent directory in new buffer' }},
            -- Reload directory
            ["<F5>"] = { '<cmd>lua require("drex").reload_directory()<CR>', { desc = 'reload' }},
            -- Jump to next sibling
            gj = { '<cmd>lua require("drex.actions.jump").jump_to_next_sibling()<CR>', { desc = 'jump to next sibling' }},
            -- Jump to previous sibling
            gk = { '<cmd>lua require("drex.actions.jump").jump_to_prev_sibling()<CR>', { desc = 'jump to prev sibling' }},
            -- Jump to parent element
            gh = { '<cmd>lua require("drex.actions.jump").jump_to_parent()<CR>', { desc = 'jump to parent element' }},
            -- Show element stats
            s = { '<cmd>lua require("drex.actions.stats").stats()<CR>', { desc = 'show element stats' }},
            -- Create new file or directory
            a = { '<cmd>lua require("drex.actions.files").create()<CR>', { desc = 'create element' }},
            -- Delete element (line)
            d = { '<cmd>lua require("drex.actions.files").delete("line")<CR>', { desc = 'delete element' }},
            -- Delete all elements in clipboard
            D = { '<cmd>lua require("drex.actions.files").delete("clipboard")<CR>', { desc = 'delete (clipboard)' }},
            -- Copy and paste (clipboard)
            p = { '<cmd>lua require("drex.actions.files").copy_and_paste()<CR>', { desc = 'copy & paste (clipboard)' }},
            -- Cut and move (clipboard)
            P = { '<cmd>lua require("drex.actions.files").cut_and_move()<CR>', { desc = 'cut & move (clipboard)' }},
            -- Rename element
            r = { '<cmd>lua require("drex.actions.files").rename()<CR>', { desc = 'rename element' }},
            -- Multi-rename (clipboard)
            R = { '<cmd>lua require("drex.actions.files").multi_rename("clipboard")<CR>', { desc = 'rename (clipboard)' }},
            -- Search
            ["/"] = { '<cmd>keepalt lua require("drex.actions.search").search()<CR>', { desc = 'search' }},
            -- Mark element
            M = { '<cmd>DrexMark<CR>', { desc = 'mark element' }},
            -- Unmark element
            u = { '<cmd>DrexUnmark<CR>', { desc = 'unmark element' }},
            -- Toggle mark
            m = { '<cmd>DrexToggle<CR>', { desc = 'toggle element' }},
            -- Clear clipboard
            cc = { '<cmd>lua require("drex.clipboard").clear_clipboard()<CR>', { desc = 'clear clipboard' }},
            -- Edit clipboard in floating window
            cs = { '<cmd>lua require("drex.clipboard").open_clipboard_window()<CR>', { desc = 'edit clipboard' }},
            -- Copy element name
            y = { '<cmd>lua require("drex.actions.text").copy_name()<CR>', { desc = 'copy element name' }},
            -- Copy relative path
            Y = { '<cmd>lua require("drex.actions.text").copy_relative_path()<CR>', { desc = 'copy element relative path' }},
            -- Copy absolute path
            ["<C-y>"] = { '<cmd>lua require("drex.actions.text").copy_absolute_path()<CR>', { desc = 'copy element absolute path' }},
          },
          -- Visual mode keybindings
          v = {
            -- Delete selected elements
            d = { ':lua require("drex.actions.files").delete("visual")<CR>', { desc = 'delete elements' }},
            -- Multi-rename selected elements
            r = { ':lua require("drex.actions.files").multi_rename("visual")<CR>', { desc = 'rename elements' }},
            -- Mark selected elements
            M = { ':DrexMark<CR>', { desc = 'mark elements' }},
            -- Unmark selected elements
            u = { ':DrexUnmark<CR>', { desc = 'unmark elements' }},
            -- Toggle mark for selected elements
            m = { ':DrexToggle<CR>', { desc = 'toggle elements' }},
            -- Copy names of selected elements
            y = { ':lua require("drex.actions.text").copy_name(true)<CR>', { desc = 'copy element names' }},
            -- Copy relative paths of selected elements
            Y = { ':lua require("drex.actions.text").copy_relative_path(true)<CR>', { desc = 'copy element relative paths' }},
            -- Copy absolute paths of selected elements
            ["<C-y>"] = { ':lua require("drex.actions.text").copy_absolute_path(true)<CR>', { desc = 'copy element absolute paths' }},
          },
        },
  
        -- Function to run when entering a drex buffer
        on_enter = nil,
        -- Function to run when leaving a drex buffer
        on_leave = nil,
      }
  
      -- Optional: Add a keymap to open drex easily
      -- \ <leader>e will open drex in the current working directory
      vim.keymap.set("n", "<leader>e", ":Drex<CR>", { desc = "Open Drex" })
    end,
}
  