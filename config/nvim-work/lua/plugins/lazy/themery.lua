-- Themery https://github.com/zaldih/themery.nvim

local theme_menu_items = {
    "bluloco-dark",
    "bluloco-light",
    "carbonfox",
    "dawnfox",
    "dayfox",
    "duskfox",
    "eldritch",
    "kanagawa-dragon",
    "kanagawa-lotus",
    "kanagawa-wave",
    "modus_operandi",
    "modus_vivendi",
    "moonfly",
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
    "nightfox",
    "nordfox",
    "one_monokai",
    "oxocarbon",
    "poimandres",
    "rusty",
    "terafox",
    "vague",
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
