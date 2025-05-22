-- Themery https://github.com/zaldih/themery.nvim

local theme_menu_itmes = {
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "catppuccin-mocha",
    "edge",
    "ef-owl",
    "ef-winter",
    "everforest",
    "horizon-extended",
    "monokai",
    "nightfly",
    "nordic",
    "onedark",
    -- "onedarkpro",
    "PaperColor",
    "tokyonight-moon",
    "tokyonight-night",
    "vscode_modern",
    "zenburn"
}

return {
    enabled = true,
    "zaldih/themery.nvim",
    config = function()
        require("themery").setup({
            themes = theme_menu_itmes,
            livePreview = true,
        })
    end,
}
