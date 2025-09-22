return {
  -- Themery - Theme picker plugin
  {
    "zaldih/themery.nvim",
    lazy = false,  -- Load immediately
    priority = 1001,  -- Higher priority than themes (1000) to load first
    cmd = "Themery",
    config = function()
      require("themery").setup({
        themes = {
          {
            name = "Gruvbox Dark",
            colorscheme = "gruvbox",
            before = [[
              vim.o.background = "dark"
            ]],
          },
          {
            name = "Gruvbox Light",
            colorscheme = "gruvbox",
            before = [[
              vim.o.background = "light"
            ]],
          },
          {
            name = "Tokyo Night",
            colorscheme = "tokyonight",
          },
          {
            name = "Tokyo Night Storm", 
            colorscheme = "tokyonight-storm",
          },
          {
            name = "Tokyo Night Moon",
            colorscheme = "tokyonight-moon",
          },
          {
            name = "Tokyo Night Day",
            colorscheme = "tokyonight-day",
          },
          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin-mocha",
          },
          {
            name = "Catppuccin Macchiato",
            colorscheme = "catppuccin-macchiato",
          },
          {
            name = "Catppuccin Frappe",
            colorscheme = "catppuccin-frappe",
          },
          {
            name = "Catppuccin Latte",
            colorscheme = "catppuccin-latte",
          },
          {
            name = "One Dark",
            colorscheme = "onedark",
          },
          {
            name = "Kanagawa",
            colorscheme = "kanagawa",
          },
          {
            name = "Nord",
            colorscheme = "nord",
          },
          {
            name = "Dracula",
            colorscheme = "dracula",
          },
          {
            name = "Nightfly",
            colorscheme = "nightfly",
          },
          {
            name = "Palenight",
            colorscheme = "palenight",
          },
          {
            name = "Oxocarbon",
            colorscheme = "oxocarbon",
            before = [[
              vim.opt.background = "dark"
            ]],
          },
        },
        livePreview = true,
      })
    end,
  },
}