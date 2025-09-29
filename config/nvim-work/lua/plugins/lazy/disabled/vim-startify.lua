-- vim-startify https://github.com/mhinz/vim-startify

return {
    "mhinz/vim-startify",
    lazy = false, -- Must load immediately for startup screen to work
    priority = 1200, -- Load before Neorg (1000) and other plugins that might interfere
    config = function()
        -- Ensure startify loads properly and shows on startup
        vim.g.startify_disable_at_vimenter = 0
        vim.g.startify_enable_special = 1
        
        -- Startify configuration
        vim.g.startify_session_dir = '~/.config/nvim/session'
        
        -- Startify lists - customize what appears on the start screen
        vim.g.startify_lists = {
            { type = 'files',     header = {'   Recent Files'} },
            { type = 'dir',       header = {'   Current Directory'} },
            { type = 'sessions',  header = {'   Sessions'} },
            { type = 'bookmarks', header = {'   Bookmarks'} },
        }
        
        -- Bookmarks - add your frequently accessed files/directories
        vim.g.startify_bookmarks = {
            { i = '~/.config/nvim/init.lua' },
            { z = '~/.zshrc' },
            { p = '~/projects' },
        }
        
        -- Custom header
        vim.g.startify_custom_header = {
            '        ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
            '        ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
            '        ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
            '        ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
            '        ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
            '        ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
            '                                                           ',
            '                    [ WORK ENVIRONMENT ]                   ',
            '',
        }
        
        -- Center the header
        vim.g.startify_custom_header_quotes = {}
        
        -- Skip certain files from recent files list
        vim.g.startify_skiplist = {
            'COMMIT_EDITMSG',
            '\\v/\\.git/',
            'node_modules/',
            '\\.DS_Store',
        }
        
        -- Change directory when opening a file/bookmark
        vim.g.startify_change_to_dir = 1
        
        -- Number of files to show in recent files
        vim.g.startify_files_number = 10
        
        -- Enable unsafe commands (for sessions)
        vim.g.startify_enable_unsafe = 1
        
        -- Session persistence
        vim.g.startify_session_persistence = 1
        vim.g.startify_session_autoload = 0 -- Disable auto-loading sessions on startup
        
        -- Custom indices for better navigation
        vim.g.startify_custom_indices = {'f', 'd', 's', 'a', 'g', 'h', 'j', 'k', 'l'}
        
        -- Set up keymaps
        vim.keymap.set('n', '<leader>st', ':Startify<CR>', { desc = 'Open Startify' })
        vim.keymap.set('n', '<leader>ss', ':SSave<CR>', { desc = 'Save Session' })
        vim.keymap.set('n', '<leader>sl', ':SLoad<CR>', { desc = 'Load Session' })
        vim.keymap.set('n', '<leader>sd', ':SDelete<CR>', { desc = 'Delete Session' })
        vim.keymap.set('n', '<leader>sc', ':SClose<CR>', { desc = 'Close Session' })
        
        -- Debug: Create an autocmd to check if startify is working
        vim.api.nvim_create_autocmd("User", {
            pattern = "StartifyReady",
            callback = function()
                print("Startify loaded successfully!")
            end,
        })
        
        -- Force startify to show on startup if no files are opened
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                -- Use a timer to ensure startify shows even if other plugins interfere
                vim.defer_fn(function()
                    -- Check if we started without arguments (no files specified)
                    if vim.fn.argc() == 0 then
                        -- If any plugin opened a file automatically, close it and show startify
                        local buf_name = vim.api.nvim_buf_get_name(0)
                        if buf_name ~= "" and buf_name:match("%.norg$") then
                            -- A norg file was auto-opened, close it and show startify
                            vim.cmd('bdelete')
                            vim.cmd('Startify')
                        elseif buf_name == "" then
                            -- No file opened, show startify normally
                            local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                            local is_empty = #buf_lines == 1 and buf_lines[1] == ""
                            if is_empty then
                                vim.cmd('Startify')
                            end
                        end
                    end
                end, 50) -- Increased delay to 50ms to let Neorg settle if it tries to auto-open
            end,
        })
    end,
}