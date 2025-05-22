-- Cokeline https://github.com/willothy/nvim-cokeline

return {
    enabled = true,
    "willothy/nvim-cokeline",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- Optional, for icons
        "nvim-tree/nvim-web-devicons",
        -- Optional, for session history
        "stevearc/resession.nvim",
    },
    config = function()
        require('cokeline').setup({
            show_if_buffers_are_at_least = 1,
            default_hl = {
                fg = function(buffer)
                    return buffer.is_focused and require('cokeline.hlgroups').get_hl_attr('Normal', 'fg')
                        or require('cokeline.hlgroups').get_hl_attr('Comment', 'fg')
                end,
                bg = 'NONE',
            },
            components = {
                {
                    text = function(buffer) return ' ' .. buffer.devicon.icon end,
                    fg = function(buffer) return buffer.devicon.color end,
                },
                {
                    text = function(buffer) return buffer.filename .. ' ' end,
                    bold = function(buffer) return buffer.is_focused end,
                },
                {
                    text = '', -- close button
                    on_click = function(_, _, _, _, buffer) buffer:delete() end,
                },
                { text = ' ', },
            },
        })
    end,
    keys = {
        -- Buffer navigation
        { "<S-h>", "<Plug>(cokeline-focus-prev)", desc = "Previous buffer" },
        { "<S-l>", "<Plug>(cokeline-focus-next)", desc = "Next buffer" },
        -- Buffer picking
        { "<leader>bp", "<Plug>(cokeline-pick-focus)", desc = "Pick buffer" },
        { "<leader>bc", "<Plug>(cokeline-pick-close)", desc = "Pick buffer to close" },
        -- New buffer
        { "<leader>bn", ":enew<CR>", desc = "New buffer" }
    },
}

