-- OneDark theme https://github.com/navarasu/onedark.nvim

return {
    enabled = true,
    "navarasu/onedark.nvim",
    name = "onedark",
    config = function()
        require("onedark").setup({
            -- Options: dark, darker, cool, deep, warm, warmer
            style = "darker"
        })
    end
}