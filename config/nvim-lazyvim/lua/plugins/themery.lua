-- Themery theme picker configuration
-- Reduced list of most commonly used themes for better performance
-- You can re-add more themes if needed, but this improves startup time significantly
local theme_menu_items = {
  -- Aura variants
  { name = "Aura Dark", colorscheme = "aura-dark" },
  { name = "Aura Soft Dark", colorscheme = "aura-soft-dark" },
  
  -- Catppuccin variants
  { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
  { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
  
  -- Popular themes
  { name = "Dracula", colorscheme = "dracula" },
  { name = "Eldritch", colorscheme = "eldritch" },
  { name = "Gruvbox", colorscheme = "gruvbox" },
  { name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
  { name = "Nightfly", colorscheme = "nightfly" },
  { name = "Nord", colorscheme = "nord" },
  { name = "OneDark", colorscheme = "onedark" },
  { name = "One Monokai", colorscheme = "one_monokai" },
  { name = "Oxocarbon", colorscheme = "oxocarbon" },
  { name = "Tokyo Night", colorscheme = "tokyonight" },
  { name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
  { name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
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