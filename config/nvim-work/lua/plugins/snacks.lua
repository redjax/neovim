-- Snacks https://github.com/

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
        "echasnovski/mini.icons",
        "nvim-tree/nvim-web-devicons",
    },
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        animate = { enabled = true },  -- https://github.com/folke/snacks.nvim/blob/main/docs/animate.md
        bigfile = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
        bufdelete = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md
        dashboard = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
        debug = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
        dim = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/dim.md
        explorer = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
        git = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/git.md
        gitbrowse = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md
        image = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/image.md
        indent = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
        input = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/input.md
        layout = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/layout.md
        lazygit = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
        notifier = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
        notify = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/notify.md
        picker = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
        profiler = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/profiler.md
        quickfile = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md
        scope = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/scope.md
        scratch = { enabled = false}, -- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
        scroll = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md
        statuscolumn = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
        terminal = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
        toggle = { enableed = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md
        util = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/util.md
        win = { enabled = false }, -- https://github.com/folke/snacks.nvim/blob/main/docs/win.md
        words = { enabled = true }, -- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
        zen = { enabled = false } -- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md
    },
}