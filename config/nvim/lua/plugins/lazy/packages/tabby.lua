-- Tabby https://github.com/nanozuki/tabby.nvim

return {
    enabled = true,
    "nanozuki/tabby.nvim",
    -- Set to "UIEnter" or remove for eager loading, or "VeryLazy" for lazy loading
    event = "VeryLazy",
    config = function()
        require("tabby").setup()
    end,
}
