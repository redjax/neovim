-- Noice UI folke/noice.nvim

return {
    enabled = false,
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require("noice").setup()
    end,
}
