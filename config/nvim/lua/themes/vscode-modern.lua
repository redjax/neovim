-- VSCode Modern theme https://github.com/gmr458/vscode_modern_theme.nvim

return {
    enbaled = true,
    "gmr458/vscode_modern_theme.nvim",
    name = "vscode_modern",
    lazy = false,
    priority = 1000,
    config = function()
        require("vscode_modern").setup({
            cursorline = true,
            transparent_background = false,
            nvim_tree_darker = true,
        })
    end,
}