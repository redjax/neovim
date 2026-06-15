return {
	src = "https://github.com/mason-org/mason.nvim",
	name = "mason.nvim",
	event = "VimEnter",
	lazy = true,

	setup = function()
		require("mason").setup({
			registries = {
				"github:mason-org/mason-registry",
			},
		})
	end,
}
