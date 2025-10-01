-- Noice UI folke/noice.nvim https://github.com/folke/noice.nvim

return {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require("noice").setup()
    end,
}
