-- Nordic theme https://github.com/AlexvZyl/nordic.nvim

return {
    enabled = true,
    'AlexvZyl/nordic.nvim',
    name = "nordic",
    config = function()
        require('nordic').load()
    end
}
