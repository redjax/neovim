-- Ayu theme https://github.com/Shatur/neovim-ayu

return {
    enabled = true,
    "Shatur/neovim-ayu",
    name = "ayu",
    lazy = false,
    priority = 1000,
    init = function()
        -- Options: ayu-dark, ayu-light, ayu-mirage
        vim.g.ayu_style = 'ayu-dark'
    end,
}