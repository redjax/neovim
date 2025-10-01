-- Neotree https://github.com/

return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    -- Check latest release: https://github.com/nvim-neo-tree/neo-tree.nvim/releases
    -- \ Use major.x, i.e. 3.33 --> "v3.x"
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
       -- optional, for file icons
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- Optional: for window picker support
      -- {
      --   "s1n7ax/nvim-window-picker",
      --   version = "2.*",
      --   config = function()
      --     require("window-picker").setup({
      --       filter_rules = {
      --         include_current_win = false,
      --         autoselect_one = true,
      --         bo = {
      --           filetype = { "neo-tree", "neo-tree-popup", "notify" },
      --           buftype = { "terminal", "quickfix" },
      --         },
      --       },
      --     })
      --   end,
      -- },
    },
    config = function()
      require("neo-tree").setup({
        -- Close Neo-tree if it is the last window left in the tab
        close_if_last_window = false,
        -- Add a blank line at top of tree
        add_blank_line_at_top = false,
        -- Automatically clean up broken neotree buffers saved in sessions
        auto_clean_after_session_restore = true,
        -- Border style for popups ("NC", "rounded", "single", etc.)
        popup_border_style = "NC",
        -- Options: filesystem, last
        default_source = "filesystem",
        -- Enable git status integration
        enable_git_status = true,
        -- Enable diagnostics integration (shows LSP diagnostics in tree)
        enable_diagnostics = true,
        -- Filetypes/buftypes NOT to be replaced when opening files from Neo-tree
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        -- Use relative paths when opening files
        open_files_using_relative_paths = false,
        -- Show markers for files with unsaved changes.
        enable_modified_markers = true,
        -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
        enable_opened_markers = true,  
        -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
        enable_refresh_on_write = true,
        -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
        enable_cursor_hijack = false,
        git_status_async = true,
        -- These options are for people with VERY large git repos
        git_status_async_options = {
            batch_size = 1000, -- how many lines of git status results to process at a time
            batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
            max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
                            -- Anything before this will be used. The last items to be processed are the untracked files.
        },
        hide_root_node = false,
        -- If root node is hidden, keep indentation
        retain_hidden_root_indent = false,
        -- Ignore case when sorting files/directories
        sort_case_insensitive = false,
        -- When opening files, do not use windows containing these filetypes or buftypes
        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
        -- Custom sort function (set to nil to use default)
        -- sort_function = nil,
        -- Default component configs (icons, indentation, git status, etc.)
        default_component_configs = {
          -- Container for all components
          container = {
            -- Enable faded color for non-focused items
            enable_character_fade = true,
          },
          -- Indentation and expanders
          indent = {
            -- Number of spaces per indent level
            indent_size = 2,
            -- Extra padding on the left
            padding = 1,
            -- Show indent guides
            with_markers = true,
            -- Character for indent marker
            indent_marker = "│",
            -- Character for last indent marker
            last_indent_marker = "└",
            -- Highlight group for indent markers
            highlight = "NeoTreeIndentMarker",
            -- Enable expanders for nested files/folders
            with_expanders = nil,
            -- Collapsed expander symbol
            expander_collapsed = "",
            -- Expanded expander symbol
            expander_expanded = "",
            -- Highlight group for expanders
            expander_highlight = "NeoTreeExpander",
          },
          -- Icons for files/folders
          icon = {
            -- Closed folder icon
            folder_closed = "",
            -- Open folder icon
            folder_open = "",
            -- Empty folder icon
            folder_empty = "",
            -- Provider function for icons (uses nvim-web-devicons if available)
            -- provider = ... (default uses devicons)
            -- Fallback icon and highlight
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          -- Symbol for modified files
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          -- File name display options
          name = {
            -- Show trailing slash for folders
            trailing_slash = false,
            -- Use git status colors for file names
            use_git_status_colors = true,
            -- Highlight group for file names
            highlight = "NeoTreeFileName",
          },
          -- Git status symbols
          git_status = {
            symbols = {
              -- Symbol for added files
              added = "",
              -- Symbol for modified files
              modified = "",
              -- Symbol for deleted files
              deleted = "✖",
              -- Symbol for renamed files
              renamed = "",
              -- Symbol for untracked files
              untracked = "",
              -- Symbol for ignored files
              ignored = "",
              -- Symbol for unstaged changes
              unstaged = "",
              -- Symbol for staged changes
              staged = "",
              -- Symbol for conflicts
              conflict = "",
            },
          },
          -- File size column
          file_size = {
            enabled = true,
            width = 12,
            required_width = 64,
          },
          -- File type column
          type = {
            enabled = true,
            width = 10,
            required_width = 122,
          },
          -- Last modified column
          last_modified = {
            enabled = true,
            width = 20,
            required_width = 88,
          },
          -- Created date column
          created = {
            enabled = true,
            width = 20,
            required_width = 110,
          },
          -- Symlink target column
          symlink_target = {
            enabled = false,
          },
        },
        -- Global custom commands (see :h neo-tree-custom-commands-global)
        commands = {},
        -- Window options
        window = {
          -- Sidebar position ("left", "right", "top", "bottom", etc.)
          position = "left",
          -- Sidebar width (in columns)
          width = 40,
          -- Mapping options for window keymaps
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          -- Key mappings for the Neo-tree window
          mappings = {
            -- Toggle node expand/collapse
            ["<space>"] = { "toggle_node", nowait = false },
            -- Open node (file/directory)
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            -- Close preview or floating Neo-tree window
            ["<esc>"] = "cancel",
            -- Toggle preview (floating)
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            -- Focus preview window
            ["l"] = "focus_preview",
            -- Open file in horizontal split
            ["S"] = "open_split",
            -- Open file in vertical split
            ["s"] = "open_vsplit",
            -- Open file in new tab
            ["t"] = "open_tabnew",
            -- Open file with window picker
            ["w"] = "open_with_window_picker",
            -- Close node/folder
            ["C"] = "close_node",
            -- Close all nodes
            ["z"] = "close_all_nodes",
            -- Add a file
            ["a"] = { "add", config = { show_path = "none" } },
            -- Add a directory
            ["A"] = "add_directory",
            -- Delete file/directory
            ["d"] = "delete",
            -- Rename file/directory
            ["r"] = "rename",
            -- Rename only the basename
            ["b"] = "rename_basename",
            -- Copy to clipboard
            ["y"] = "copy_to_clipboard",
            -- Cut to clipboard
            ["x"] = "cut_to_clipboard",
            -- Paste from clipboard
            ["p"] = "paste_from_clipboard",
            -- Copy file/directory
            ["c"] = "copy",
            -- Move file/directory
            ["m"] = "move",
            -- Close Neo-tree window
            ["q"] = "close_window",
            -- Refresh Neo-tree
            ["R"] = "refresh",
            -- Show help
            ["?"] = "show_help",
            -- Previous/next source
            ["<"] = "prev_source",
            [">"] = "next_source",
            -- Show file details
            ["i"] = "show_file_details",
          },
          -- Nesting rules for files/folders
          nesting_rules = {},
        },
        -- Filesystem source options
        filesystem = {
          -- Filtered items (hidden, dotfiles, etc.)
          filtered_items = {
            -- Show filtered items differently instead of hiding
            visible = false,
            -- Hide dotfiles
            hide_dotfiles = true,
            -- Hide gitignored files
            hide_gitignored = true,
            -- Hide hidden files (Windows only)
            hide_hidden = true,
            -- Hide by file/folder name
            hide_by_name = {},
            -- Hide by glob pattern
            hide_by_pattern = {},
            -- Always show these (even if hidden by other rules)
            always_show = {},
            -- Always show by glob pattern
            always_show_by_pattern = {},
            -- Never show these (overrides always_show)
            never_show = {},
            -- Never show by glob pattern
            never_show_by_pattern = {},
          },
          -- Follow the current file in the buffer
          follow_current_file = {
            enabled = false,
            -- Leave directories open when following files
            leave_dirs_open = false,
          },
          -- Group empty directories together
          group_empty_dirs = false,
          -- Netrw hijack behavior ("open_default", "open_current", "disabled")
          hijack_netrw_behavior = "open_default",
          -- Use OS-level file watchers (libuv) for changes
          use_libuv_file_watcher = false,
          -- Filesystem window mappings (see :h neo-tree-mappings)
          window = {
            mappings = {
              -- Navigate up a directory
              ["<bs>"] = "navigate_up",
              -- Set root to current directory
              ["<space>"] = "set_root",
              -- Toggle hidden files
              ["H"] = "toggle_hidden",
              -- Fuzzy finder
              ["/"] = "fuzzy_finder",
              -- Fuzzy finder for directories
              ["D"] = "fuzzy_finder_directory",
              -- Fuzzy sorter (fzy algorithm)
              ["#"] = "fuzzy_sorter",
              -- Filter on submit
              ["f"] = "filter_on_submit",
              -- Clear filter
              ["<c-x>"] = "clear_filter",
              -- Previous/next git modified file
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              -- Help and ordering
              ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["og"] = { "order_by_git_status", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
            -- Fuzzy finder popup keymaps
            fuzzy_finder_mappings = {
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
              ["<esc>"] = "close",
            },
          },
          -- Custom filesystem commands
          commands = {},
        },
        -- Buffers source options
        buffers = {
          -- Follow current file in buffer
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          -- Group empty directories
          group_empty_dirs = true,
          -- Show unloaded buffers
          show_unloaded = true,
          -- Buffer window mappings
          window = {
            mappings = {
              ["d"] = "buffer_delete",
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
          -- Custom buffer commands
          commands = {},
        },
        -- Git status source options
        git_status = {
          -- Git status window mappings
          window = {
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
              ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
          -- Custom git status commands
          commands = {},
        },
    })

    -- Bind <Leader>e (space+e) to toggle Neo-tree
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
    end,
}
  