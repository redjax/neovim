-- One Monkai theme https://github.com/cpea2506/one_monokai.nvim

return {
    "cpea2506/one_monokai.nvim",
    name = "one_monokai",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        require("one_monokai").setup({
            transparent = false,
            colors = {},
            highlights = function(colors)
                return {}
            end,
            italics = true,
        })
    end
}