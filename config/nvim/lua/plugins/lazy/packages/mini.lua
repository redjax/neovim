-- mini.nvim https://github.com/echasnovski/mini.nvim

return {
    enabled = true,
    "echasnovski/mini.nvim",
    -- Use `version = false` for latest (main branch). Use `version = '*'` for stable.
    version = "*",
    config = function()
        -- Add mini modules you want
        -- \ All modules: https://github.com/echasnovski/mini.nvim/tree/main#modules

        -- Extended text objects
        require('mini.ai').setup()
        -- Align text
        require('mini.align').setup()
        -- Move codeblocks with <M> keys
        require('mini.move').setup()
        -- Text operators
        require('mini.operators').setup()
        -- Highlight text under cursor
        require('mini.cursorword').setup()
        -- Completion/symbols
        require('mini.completion').setup()
        -- Keymappings
        require('mini.keymap').setup()
        -- Surround text objects
        require('mini.surround').setup()
        -- Autopairs
        require('mini.pairs').setup()
        -- Commenting
        require('mini.comment').setup()
        -- Visualize & work with indent scope
        require('mini.indentscope').setup()
        -- Startup screen
        -- require('mini.starter').setup()

        -- Window and cursor animations
        require('mini.animate').setup({
            -- All animations have a default duration of 250

            cursor = {
                enable = true,
                -- Animation timing: 250ms total duration, linear progression
                timing = require('mini.animate').gen_timing.linear({ duration = 20, unit = "total" }),
            },
            scroll = {
                enable = true,
                timing = require('mini.animate').gen_timing.linear({ duration = 35, unit = "total" }),
            },
            resize = {
                enable = true,
                timing = require('mini.animate').gen_timing.linear({ duration = 60, unit = "total" }),
            },
            open = {
                enable = true,
                timing = require('mini.animate').gen_timing.linear({ duration = 10, unit = "total" }),
            },
            close = {
                enable = true,
                timing = require('mini.animate').gen_timing.linear({ duration = 10, unit = "total" }),
            },
        })

        -- Code minimap
        -- require('mini.map').setup()

        -- -- Auto-open minimap for text/code filetypes
        -- local minimap_filetypes = {
        --     "lua", "python", "javascript", "typescript", "go", "rust",
        --     "markdown", "text", "json", "yaml", "toml", "c", "cpp", "java", "sh"
        -- }

        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = minimap_filetypes,
        --     callback = function()
        --         MiniMap.open()
        --     end,
        -- })

        -- Next-key clues
        require('mini.clue').setup({
            triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },
                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },
                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },
                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },
                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },
                -- Window commands
                { mode = 'n', keys = '<C-w>' },
                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },
            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                require('mini.clue').gen_clues.builtin_completion(),
                require('mini.clue').gen_clues.g(),
                require('mini.clue').gen_clues.marks(),
                require('mini.clue').gen_clues.registers(),
                require('mini.clue').gen_clues.windows(),
                require('mini.clue').gen_clues.z(),
            },
            window = {
                delay = 500, -- Show clue window after 500ms (default is 1000ms)
            },
        })

        -- Mini file explorer
        -- require('mini.files').setup()

        -- vim.keymap.set("n", "-", function()
        --     require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        -- end, { desc = "Open mini.files (current file's directory)" })

        -- -- Comment out above line and uncomment below to always open current file's directory
        -- -- vim.keymap.set("n", "-", function()
        -- --     require("mini.files").open(nil, true)
        -- -- end, { desc = "Open mini.files (cwd)" })

        -- Session manager
        -- require('mini.sessions').setup()
        -- -- Session manager keybinds
        -- vim.keymap.set('n', '<leader>sw', MiniSessions.write, { desc = 'Write session' })
        -- vim.keymap.set('n', '<leader>sr', MiniSessions.read,  { desc = 'Read session' })
        -- vim.keymap.set('n', '<leader>sd', MiniSessions.delete, { desc = 'Delete session' })

        -- Track filesystem visits
        require('mini.visits').setup()
    end,
}
