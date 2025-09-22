-- Themery theme picker configuration
-- List of available themes that will be automatically converted to Themery format
local theme_menu_items = {
  "catppuccin-mocha",
  "catppuccin-macchiato",
  "catppuccin-frappe",
  "catppuccin-latte",
  "dracula",
  "gruvbox",
  "kanagawa-dragon",
  "kanagawa-lotus",
  "kanagawa-wave",
  "nightfly",
  "nord",
  "onedark",
  "oxocarbon",
  "palenight",
  "tokyonight",
  "tokyonight-storm", 
  "tokyonight-moon",
  "tokyonight-day",
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