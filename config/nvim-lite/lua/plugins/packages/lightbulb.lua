-- Lightbulb https://github.com/kosayoda/nvim-lightbulb
return {
    enabled = true,
    'kosayoda/nvim-lightbulb',
    config = function()
        local lightbulb = require("nvim-lightbulb")
        lightbulb.setup({})
    end
}