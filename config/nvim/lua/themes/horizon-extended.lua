-- Horizon Extended theme https://github.com/lancewilhelm/horizon-extended.nvim

return { 
    "lancewilhelm/horizon-extended.nvim",
    name = "horizon-extended",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    init = function()
        -- Options: 'neo', 'beam', 'ray'
        vim.g.horizon_style = 'neo'
    end,
}