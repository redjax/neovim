-- Themery https://github.com/zaldih/themery.nvim

local theme_menu_items = {
    "aura-dark",
    "aura-dark-soft-text",
    "aura-soft-dark",
    "aura-soft-dark-soft-text",
    "ayu",
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "catppuccin-mocha",
    "dracula",
    "edge",
    "ef-owl",
    "ef-winter",
    "everforest",
    "horizon-extended",
    "monokai",
    "moonfly",
    "nightfly",
    "nordic",
    "onedark",
    -- "onedarkpro",
    "oxocarbon",
    "PaperColor",
    "palenightfall",
    "penumbra",
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
            themes = theme_menu_items,
            livePreview = true,
        })
    end,
}
