-- Tabby https://github.com/nanozuki/tabby.nvim

return {
    src = "https://github.com/nanozuki/tabby.nvim",
    name = "tabby.nvim",
    version = "main",
    setup = function()
        require("tabby").setup()
    end,
}
