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
        -- Animations
        require('mini.animate').setup()

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
    end,
}
