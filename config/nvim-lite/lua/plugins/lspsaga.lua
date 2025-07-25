-- LSPSaga https://github.com/nvimdev/lspsaga.nvim

return {
    enabled = true,
    "nvimdev/lspsaga.nvim",
    event = "LspAttach", -- loads when LSP attaches to a buffer
    dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional but recommended
        "nvim-tree/nvim-web-devicons"      -- optional for icons
    },
    opts = {
        ui = { border = "rounded" }
    },
}
