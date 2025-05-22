-- OneDark theme https://github.com/navarasu/onedark.nvim

return {
    enabled = true,
    "navarasu/onedark.nvim",
    name = "onedark",
    lazy = false,
    priority = 1000,
    config = function()
        require("onedark").setup({
            -- Options: dark, darker, cool, deep, warm, warmer
            style = "darker"
        })
    end
}