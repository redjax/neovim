-- Themery https://github.com/zaldih/themery.nvim

local theme_menu_items = {
    "eldritch",
    "kanagawa-dragon",
    "kanagawa-lotus",
    "kanagawa-wave",
    "nekonight-arcdark",
    "nekonight-aurora",
    "nekonight-day",
    "nekonight-deep-ocean",
    "nekonight-doom-one",
    "nekonight-dracula",
    "nekonight-dracula-at-night",
    "nekonight-fire-obsidian",
    "nekonight-material-theme",
    "nekonight-moon",
    "nekonight-moonlight",
    "nekonight-nord",
    "nekonight-onedark-deep",
    "nekonight-shades-of-purple",
    "nekonight-shades-of-purple-dark",
    "nekonight-night",
    "nekonight-noctis-uva",
    "nekonight-palenight",
    "nekonight-sky-blue",
    "nekonight-space",
    "nekonight-storm",
    "nekonight-synthwave",
    "nekonight-zenburn",
    "one_monokai",
    "oxocarbon",
    "poimandres",
    "vscode_modern"
}

return {
    "zaldih/themery.nvim",
    lazy = false,  -- Load immediately so it's always available
    priority = 1001,  -- Higher priority than themes (1000) to load first
    cmd = "Themery",  -- Also load on command
    config = function()
        require("themery").setup({
            themes = theme_menu_items,
            livePreview = true,
        })
    end,
}
