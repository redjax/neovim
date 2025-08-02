-- Toggleterm http://github.com/

return {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        -- Size can be a number or a function
        size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
        return 20
        end,
        open_mapping = [[<c-\>]],
        -- Uncomment and implement these as needed:
        -- on_create = function(t) end,
        -- on_open = function(t) end,
        -- on_close = function(t) end,
        -- on_stdout = function(t, job, data, name) end,
        -- on_stderr = function(t, job, data, name) end,
        -- on_exit = function(t, job, exit_code, name) end,
        hide_numbers = true,
        shade_filetypes = {},
        autochdir = false,
        highlights = {
        -- Normal = {
        --     guibg = "<VALUE-HERE>",
        -- },
        NormalFloat = {
            link = "Normal",
        },
        -- FloatBorder = {
        --     guifg = "<VALUE-HERE>",
        --     guibg = "<VALUE-HERE>",
        -- },
        },
        shade_terminals = true,
        -- shading_factor = -30,   -- Replace with your value
        -- shading_ratio = -3,     -- Replace with your value
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float", -- or "vertical", "horizontal", "tab", "float"
        close_on_exit = true,
        clear_env = false,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
            border = "curved",    -- or "curved", "single", "double", "shadow", etc.
            width = nil,          -- set as needed
            height = nil,         -- set as needed
            row = nil,
            col = nil,
            winblend = 3,
            zindex = nil,
            title_pos = "center", -- or "left", "right"
        },
        winbar = {
            enabled = false,
            name_formatter = function(term)
                return term.name
            end,
        },
        responsiveness = {
            horizontal_breakpoint = 135,
        },
    },
}
