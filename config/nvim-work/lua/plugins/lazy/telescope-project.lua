-- Telescope Project https://github.com/nvim-telescope/telescope-project.nvim

return {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    event = "VeryLazy", -- Load after startup
    config = function()
        -- Load the extension
        require('telescope').load_extension('project')
        
        -- Setup project configuration in telescope
        require('telescope').setup({
            extensions = {
                project = {
                    -- Dynamic base directories that work across OSes
                    base_dirs = (function()
                        local dirs = {}
                        local home = vim.fn.expand('~')
                        
                        -- Common project directories that might exist
                        local potential_dirs = {
                            'projects',
                            'dev',
                            'work',
                            'code',
                            'src',
                            'repos',
                            'git',
                            'Documents/projects',
                            'Documents/dev',
                            'Documents/code',
                        }
                        
                        -- Check which directories actually exist
                        for _, dir in ipairs(potential_dirs) do
                            local full_path = home .. '/' .. dir
                            if vim.fn.isdirectory(full_path) == 1 then
                                table.insert(dirs, {full_path, max_depth = 2})
                            end
                        end
                        
                        -- Always include current working directory
                        table.insert(dirs, vim.fn.getcwd())
                        
                        -- Add config directory (cross-platform)
                        local config_dir = vim.fn.stdpath('config')
                        if config_dir then
                            table.insert(dirs, vim.fn.fnamemodify(config_dir, ':h')) -- Parent of config dir
                        end
                        
                        return dirs
                    end)(),
                    hidden_files = false,    -- Don't show hidden files by default
                    theme = "dropdown",      -- Use dropdown theme for cleaner look
                    order_by = "recent",     -- Order by most recently used
                    search_by = {"title", "path"}, -- Search by both title and path
                    sync_with_nvim_tree = false, -- Set to true if you use nvim-tree
                    ignore_missing_dirs = true,  -- Don't error on missing directories
                    
                    -- Custom actions when project is selected
                    on_project_selected = function(prompt_bufnr)
                        -- Change to project directory and find files
                        local project_actions = require("telescope._extensions.project.actions")
                        project_actions.change_working_directory(prompt_bufnr, false)
                        -- Automatically open telescope file finder in the new project
                        vim.defer_fn(function()
                            require('telescope.builtin').find_files()
                        end, 100)
                    end,
                    
                    -- Custom mappings
                    mappings = {
                        n = {
                            ['d'] = require("telescope._extensions.project.actions").delete_project,
                            ['r'] = require("telescope._extensions.project.actions").rename_project,
                            ['c'] = require("telescope._extensions.project.actions").add_project,
                            ['C'] = require("telescope._extensions.project.actions").add_project_cwd,
                            ['f'] = require("telescope._extensions.project.actions").find_project_files,
                            ['b'] = require("telescope._extensions.project.actions").browse_project_files,
                            ['s'] = require("telescope._extensions.project.actions").search_in_project_files,
                            ['R'] = require("telescope._extensions.project.actions").recent_project_files,
                            ['w'] = require("telescope._extensions.project.actions").change_working_directory,
                        },
                        i = {
                            ['<c-d>'] = require("telescope._extensions.project.actions").delete_project,
                            ['<c-v>'] = require("telescope._extensions.project.actions").rename_project,
                            ['<c-a>'] = require("telescope._extensions.project.actions").add_project,
                            ['<c-A>'] = require("telescope._extensions.project.actions").add_project_cwd,
                            ['<c-f>'] = require("telescope._extensions.project.actions").find_project_files,
                            ['<c-b>'] = require("telescope._extensions.project.actions").browse_project_files,
                            ['<c-s>'] = require("telescope._extensions.project.actions").search_in_project_files,
                            ['<c-r>'] = require("telescope._extensions.project.actions").recent_project_files,
                            ['<c-l>'] = require("telescope._extensions.project.actions").change_working_directory,
                        }
                    }
                }
            }
        })
        
        -- Set up keymaps
        vim.keymap.set('n', '<leader>fp', function()
            require('telescope').extensions.project.project{}
        end, { desc = 'Find Projects' })
        
        vim.keymap.set('n', '<C-p>', function()
            require('telescope').extensions.project.project{}
        end, { desc = 'Find Projects' })
        
        -- Additional project-related keymaps
        vim.keymap.set('n', '<leader>fP', function()
            require('telescope').extensions.project.project{ display_type = 'full' }
        end, { desc = 'Find Projects (detailed)' })
        
        -- Quick project creation
        vim.keymap.set('n', '<leader>pc', function()
            local project_actions = require("telescope._extensions.project.actions")
            project_actions.add_project_cwd()
        end, { desc = 'Add current directory as project' })
    end,
}