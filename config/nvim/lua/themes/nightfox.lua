-- Nightfox themes https://github.com/EdenEast/nightfox.nvim

return {
    "EdenEast/nightfox.nvim",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    config = function()
        require("nightfox").setup({
            options = {
                terminal_colors = false,
            },
        })
    end,
}
