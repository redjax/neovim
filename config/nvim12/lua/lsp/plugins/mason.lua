return {
	src = "https://github.com/mason-org/mason.nvim",
	name = "mason.nvim",
	lazy = false, -- IMPORTANT

	setup = function()
		require("mason").setup({
			registries = {
				"github:mason-org/mason-registry",
			},
		})
	end,
}
