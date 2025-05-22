-- Neoscroll https://github.com/karb94/neoscroll.nvim

return {
    enabled = true,
    'karb94/neoscroll.nvim',
	    event = "VeryLazy",
	    config = function()
	        require('neoscroll').setup({
                mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>'}
            })
        end
}
