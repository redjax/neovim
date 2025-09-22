-- Ayu theme https://github.com/Shatur/neovim-ayu

return {
    "Shatur/neovim-ayu",
    name = "ayu",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    init = function()
        -- Options: ayu-dark, ayu-light, ayu-mirage
        vim.g.ayu_style = 'ayu-dark'
    end,
}