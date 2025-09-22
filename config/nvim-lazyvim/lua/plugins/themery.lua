-- Themery theme picker configuration
-- List of available themes that will be automatically converted to Themery format
local theme_menu_items = {
  "aura-dark",
  "aura-dark-soft-text",
  "aura-soft-dark",
  "aura-soft-dark-soft-text",
  "catppuccin-mocha",
  "catppuccin-macchiato",
  "catppuccin-frappe",
  "catppuccin-latte",
  "dracula",
  "eldritch",
  "gruvbox",
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
  "nightfly",
  "nord",
  "onedark",
  "one_monokai",
  "oxocarbon",
  "palenight",
  "tokyonight",
  "tokyonight-storm", 
  "tokyonight-moon",
  "tokyonight-day",
  "vscode_modern",
}

return {
  -- Themery - Theme picker plugin
  {
    "zaldih/themery.nvim",
    lazy = false,  -- Load immediately
    priority = 1001,  -- Higher priority than themes (1000) to load first
    cmd = "Themery",
    config = function()
      require("themery").setup({
        themes = theme_menu_items,
        livePreview = true,
      })
    end,
  },
}