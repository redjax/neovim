-- Nvim-tree https://github.com/nvim-tree/nvim-tree.lua

-- Function to set keybinds on nvim-tree attach
local function nvimtree_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', '?',     api.tree.toggle_help,           opts('Help'))
end


return {
    enabled = false,
    "nvim-tree/nvim-tree.lua",
    -- optional, for file icons
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        -- Disable netrw only if nvim-tree is enabled
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
        on_attach = nvimtree_on_attach,
        sort = { sorter = "case_sensitive" },
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)
    end,
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree" }
    },
}
