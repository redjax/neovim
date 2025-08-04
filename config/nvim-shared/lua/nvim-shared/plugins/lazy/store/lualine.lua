-- Lualine https://github.com/nvim-lualine/lualine.nvim

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require("lualine").setup({
            sections = {
                lualine_c = {
                    -- Enable nvim-navic
                    { function() return require("nvim-navic").get_location() end, cond = function() return require("nvim-navic").is_available() end },
                },
            }
        })
    end
}