-- Mason https://github.com/mason-org/mason-lspconfig.nvim

return {
    enable = true,
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}