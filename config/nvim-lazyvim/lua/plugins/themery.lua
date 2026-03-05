-- Themery theme picker configuration
-- Reduced list of most commonly used themes for better performance
-- You can re-add more themes if needed, but this improves startup time significantly
local theme_menu_items = {
  -- Aura variants
  { name = "Aura Dark", colorscheme = "aura-dark" },
  { name = "Aura Soft Dark", colorscheme = "aura-soft-dark" },
  
  -- Bluloco variants
  { name = "Bluloco Dark", colorscheme = "bluloco-dark" },
  { name = "Bluloco Light", colorscheme = "bluloco-light" },
  
  -- Catppuccin variants
  { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
  { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
  
  -- Popular themes
  { name = "Dracula", colorscheme = "dracula" },
  { name = "Eldritch", colorscheme = "eldritch" },
  { name = "Gruvbox", colorscheme = "gruvbox" },
  { name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
  { name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
  { name = "Kanagawa Lotus", colorscheme = "kanagawa-lotus" },
  
  -- Modus themes
  { name = "Modus Operandi", colorscheme = "modus_operandi" },
  { name = "Modus Vivendi", colorscheme = "modus_vivendi" },
  
  { name = "Moonfly", colorscheme = "moonfly" },
  
  -- Neko-Knight variants
  { name = "NekoNight ArcDark", colorscheme = "nekonight-arcdark" },
  { name = "NekoNight Aurora", colorscheme = "nekonight-aurora" },
  { name = "NekoNight Day", colorscheme = "nekonight-day" },
  { name = "NekoNight Deep Ocean", colorscheme = "nekonight-deep-ocean" },
  { name = "NekoNight Doom One", colorscheme = "nekonight-doom-one" },
  { name = "NekoNight Dracula", colorscheme = "nekonight-dracula" },
  { name = "NekoNight Dracula at Night", colorscheme = "nekonight-dracula-at-night" },
  { name = "NekoNight Fire Obsidian", colorscheme = "nekonight-fire-obsidian" },
  { name = "NekoNight Material Theme", colorscheme = "nekonight-material-theme" },
  { name = "NekoNight Moon", colorscheme = "nekonight-moon" },
  { name = "NekoNight Moonlight", colorscheme = "nekonight-moonlight" },
  { name = "NekoNight Nord", colorscheme = "nekonight-nord" },
  { name = "NekoNight OneDark Deep", colorscheme = "nekonight-onedark-deep" },
  { name = "NekoNight Shades of Purple", colorscheme = "nekonight-shades-of-purple" },
  { name = "NekoNight Shades of Purple Dark", colorscheme = "nekonight-shades-of-purple-dark" },
  { name = "NekoNight Night", colorscheme = "nekonight-night" },
  { name = "NekoNight Noctis Uva", colorscheme = "nekonight-noctis-uva" },
  { name = "NekoNight Palenight", colorscheme = "nekonight-palenight" },
  { name = "NekoNight Sky Blue", colorscheme = "nekonight-sky-blue" },
  { name = "NekoNight Space", colorscheme = "nekonight-space" },
  { name = "NekoNight Storm", colorscheme = "nekonight-storm" },
  { name = "NekoNight Synthwave", colorscheme = "nekonight-synthwave" },
  { name = "NekoNight Zenburn", colorscheme = "nekonight-zenburn" },
  
  { name = "Nightfly", colorscheme = "nightfly" },
  
  -- Nightfox variants
  { name = "Nightfox", colorscheme = "nightfox" },
  { name = "Carbonfox", colorscheme = "carbonfox" },
  { name = "Dawnfox", colorscheme = "dawnfox" },
  { name = "Dayfox", colorscheme = "dayfox" },
  { name = "Duskfox", colorscheme = "duskfox" },
  { name = "Nordfox", colorscheme = "nordfox" },
  { name = "Terafox", colorscheme = "terafox" },
  
  { name = "Nord", colorscheme = "nord" },
  { name = "OneDark", colorscheme = "onedark" },
  { name = "One Monokai", colorscheme = "one_monokai" },
  { name = "Oxocarbon", colorscheme = "oxocarbon" },
  { name = "Poimandres", colorscheme = "poimandres" },
  { name = "Rusty", colorscheme = "rusty" },
  { name = "Tokyo Night", colorscheme = "tokyonight" },
  { name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
  { name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
  { name = "Vague", colorscheme = "vague" },
  { name = "VSCode Modern", colorscheme = "vscode_modern" },
}

return {
  -- Themery - Theme picker plugin
  {
    "zaldih/themery.nvim",
    lazy = false,  -- Load at startup to restore saved theme
    priority = 999,  -- Load AFTER themes (which have priority 1000)
    cmd = "Themery",
    config = function()
      require("themery").setup({
        themes = theme_menu_items,
        livePreview = true,
      })
    end,
  },
}