-- Terminal https://github.com/

return {
    enabled = true,
    "rebelot/terminal.nvim",
    opts = {
        layout = {
        open_cmd = "float",
        width = 0.8,   -- 80% of columns
        height = 0.8,  -- 80% of lines
        },
        cmd = { vim.o.shell },
        autoclose = false,
    },
    config = function(_, opts)
        require("terminal").setup(opts)
        local term_map = require("terminal.mappings")
        vim.keymap.set("n", "<leader>tt", term_map.toggle, { noremap = true, silent = true, desc = "Toggle Terminal" })
        vim.keymap.set("n", "<leader>tr", term_map.run, { noremap = true, silent = true, desc = "Run in Terminal" })
        -- Add more keymaps as desired
    end,
}
