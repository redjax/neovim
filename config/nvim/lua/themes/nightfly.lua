-- Nightfly theme https://github.com/bluz71/vim-nightfly-colors

return {
    enabled = true,
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,         -- load on startup
    priority = 1000,      -- load before all other plugins
    config = function()
        -- Optional: set nightfly options here
        -- vim.g.nightflyItalics = false
        -- vim.cmd.colorscheme("nightfly")
    end,
}
