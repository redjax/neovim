-- Themery https://github.com/zaldih/themery.nvim
-- Configuration with lazy loading support - loads theme plugins on demand

-- Helper to create theme entry with lazy loading
local function theme(name, colorscheme, plugin_name)
    return {
        name = name,
        colorscheme = colorscheme,
        before = [[
            require("lazy").load({ plugins = { "]] .. plugin_name .. [[" } })
        ]],
    }
end

local theme_menu_items = {
    theme("Aura Dark", "aura-dark", "aura-theme"),
    theme("Aura Dark Soft Text", "aura-dark-soft-text", "aura-theme"),
    theme("Aura Soft Dark", "aura-soft-dark", "aura-theme"),
    theme("Aura Soft Dark Soft Text", "aura-soft-dark-soft-text", "aura-theme"),
    theme("Ayu", "ayu", "ayu"),
    theme("Catppuccin Frappe", "catppuccin-frappe", "catppuccin"),
    theme("Catppuccin Macchiato", "catppuccin-macchiato", "catppuccin"),
    theme("Catppuccin Mocha", "catppuccin-mocha", "catppuccin"),
    theme("Dracula", "dracula", "dracula"),
    theme("Edge", "edge", "edge"),
    theme("EF Owl", "ef-owl", "ef"),
    theme("EF Winter", "ef-winter", "ef"),
    theme("Eldritch", "eldritch", "eldritch"),
    theme("Horizon Extended", "horizon-extended", "horizon-extended"),
    theme("Kanagawa Dragon", "kanagawa-dragon", "kanagawa"),
    theme("Kanagawa Lotus", "kanagawa-lotus", "kanagawa"),
    theme("Kanagawa Wave", "kanagawa-wave", "kanagawa"),
    theme("Monokai", "monokai", "monokai"),
    theme("Moonfly", "moonfly", "nightfly"),  -- moonfly is from nightfly plugin
    theme("NekoNight ArcDark", "nekonight-arcdark", "neko-knight"),
    theme("NekoNight Aurora", "nekonight-aurora", "neko-knight"),
    theme("NekoNight Day", "nekonight-day", "neko-knight"),
    theme("NekoNight Deep Ocean", "nekonight-deep-ocean", "neko-knight"),
    theme("NekoNight Doom One", "nekonight-doom-one", "neko-knight"),
    theme("NekoNight Dracula", "nekonight-dracula", "neko-knight"),
    theme("NekoNight Dracula at Night", "nekonight-dracula-at-night", "neko-knight"),
    theme("NekoNight Fire Obsidian", "nekonight-fire-obsidian", "neko-knight"),
    theme("NekoNight Material Theme", "nekonight-material-theme", "neko-knight"),
    theme("NekoNight Moon", "nekonight-moon", "neko-knight"),
    theme("NekoNight Moonlight", "nekonight-moonlight", "neko-knight"),
    theme("NekoNight Nord", "nekonight-nord", "neko-knight"),
    theme("NekoNight OneDark Deep", "nekonight-onedark-deep", "neko-knight"),
    theme("NekoNight Shades of Purple", "nekonight-shades-of-purple", "neko-knight"),
    theme("NekoNight Shades of Purple Dark", "nekonight-shades-of-purple-dark", "neko-knight"),
    theme("NekoNight Night", "nekonight-night", "neko-knight"),
    theme("NekoNight Noctis Uva", "nekonight-noctis-uva", "neko-knight"),
    theme("NekoNight Palenight", "nekonight-palenight", "neko-knight"),
    theme("NekoNight Sky Blue", "nekonight-sky-blue", "neko-knight"),
    theme("NekoNight Space", "nekonight-space", "neko-knight"),
    theme("NekoNight Storm", "nekonight-storm", "neko-knight"),
    theme("NekoNight Synthwave", "nekonight-synthwave", "neko-knight"),
    theme("NekoNight Zenburn", "nekonight-zenburn", "neko-knight"),
    theme("Nightfly", "nightfly", "nightfly"),
    theme("Nordic", "nordic", "nordic"),
    theme("OneDark", "onedark", "onedark"),
    theme("One Monokai", "one_monokai", "one_monokai"),
    theme("Oxocarbon", "oxocarbon", "oxocarbon"),
    theme("PaperColor", "PaperColor", "papercolor"),
    theme("Palenightfall", "palenightfall", "palenightfall"),
    theme("Penumbra", "penumbra", "penumbra"),
    theme("Tokyo Night Moon", "tokyonight-moon", "tokyonight"),
    theme("Tokyo Night Night", "tokyonight-night", "tokyonight"),
    theme("VSCode Modern", "vscode_modern", "vscode_modern"),
    theme("Zenburn", "zenburn", "zenburn"),
    theme("Zephyrium", "zephyrium", "zephyrium"),
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
