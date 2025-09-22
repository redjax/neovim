-- VSCode Modern theme https://github.com/gmr458/vscode_modern_theme.nvim

return {
    "gmr458/vscode_modern_theme.nvim",
    name = "vscode_modern",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    config = function()
        require("vscode_modern").setup({
            cursorline = true,
            transparent_background = false,
            nvim_tree_darker = true,
        })
    end,
}