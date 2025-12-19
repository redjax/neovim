-- Themery theme picker configuration
-- Reduced list of most commonly used themes for better performance
-- You can re-add more themes if needed, but this improves startup time significantly
local theme_menu_items = {
  -- Aura variants
  "aura-dark",
  "aura-soft-dark",
  
  -- Catppuccin variants
  "catppuccin-mocha",
  "catppuccin-macchiato",
  
  -- Popular themes
  "dracula",
  "eldritch",
  "gruvbox",
  "kanagawa-wave",
  "nightfly",
  "nord",
  "onedark",
  "one_monokai",
  "oxocarbon",
  "tokyonight",
  "tokyonight-storm", 
  "tokyonight-moon",
  "vscode_modern",
}

return {
  -- Themery - Theme picker plugin
  {
    "zaldih/themery.nvim",
    lazy = true,  -- Only load when command is invoked
    cmd = "Themery",
    config = function()
      require("themery").setup({
        themes = theme_menu_items,
        livePreview = true,
      })
    end,
  },
}