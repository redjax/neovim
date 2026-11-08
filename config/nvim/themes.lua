--
-- [ THEME / COLORSCHEME ]
--

-- Install themes
vim.pack.add({
  -- Aura colorscheme.
  {
    src = "https://github.com/daltonmenezes/aura-theme",
    version = "main",
  },

  -- Eldritch colorscheme.
  {
    src = "https://github.com/eldritch-theme/eldritch.nvim",
    version = "master",
  },

  -- Kanagawa colorscheme.
  {
    src = "https://github.com/rebelot/kanagawa.nvim",
    version = "master",
  },

  -- Moonfly colorscheme.
  {
    src = "https://github.com/bluz71/vim-moonfly-colors",
    version = "master",
  },

  -- OneDark Pro colorscheme.
  {
    src = "https://github.com/olimorris/onedarkpro.nvim",
    version = "main",
  },

  -- Oxocarbon colorscheme.
  {
    src = "https://github.com/nyoom-engineering/oxocarbon.nvim",
    version = "main",
  },

  -- Tokyo Night colorscheme.
  {
    src = "https://github.com/folke/tokyonight.nvim",
    version = "main",
  },

  -- VSCode Modern colorscheme.
  {
    src = "https://github.com/gmr458/vscode_modern_theme.nvim",
    version = "main",
  },
})

-- Theme options
-- Load these before any colorscheme.
--

-- Eldritch theme options
require("eldritch").setup({
  styles = {
    comments = {
      italic = false,
    },
    keywords = {
      italic = false,
    },
  },
})

-- Provide a menu of installed themes and remember the selected theme.
require("themery").setup({
  themes = {
    {
      name = "Aurora",
      colorscheme = "aurora",
    },
    {
      name = "Eldritch",
      colorscheme = "eldritch",
    },
    {
      name = "Eldritch Dark",
      colorscheme = "eldritch-dark",
    },
    {
      name = "Eldritch Minimal",
      colorscheme = "eldritch-minimal",
    },
    {
      name = "Gruvbox",
      colorscheme = "gruvbox",
    },
    {
      name = "Kanagawa",
      colorscheme = "kanagawa",
    },
    {
      name = "Kanagawa Dragon",
      colorscheme = "kanagawa-dragon",
    },
    {
      name = "Kanagawa Lotus",
      colorscheme = "kanagawa-lotus",
    },
    {
      name = "Kanagawa Wave",
      colorscheme = "kanagawa-wave",
    },
    {
      name = "Moonfly",
      colorscheme = "moonfly",
    },
    {
      name = "NVCode",
      colorscheme = "nvcode",
    },
    {
      name = "OneDark",
      colorscheme = "onedark",
    },
    {
      name = "OneDark Dark",
      colorscheme = "onedark_dark",
    },
    {
      name = "OneDark Vivid",
      colorscheme = "onedark_vivid",
    },
    {
      name = "Oxocarbon",
      colorscheme = "oxocarbon",
    },
    {
      name = "Palenight",
      colorscheme = "palenight",
    },
    {
      name = "Snazzy",
      colorscheme = "snazzy",
    },
    {
      name = "Tokyo Night Moon",
      colorscheme = "tokyonight-moon",
    },
    {
      name = "Tokyo Night Night",
      colorscheme = "tokyonight-night",
    },
    {
      name = "Vaporwave",
      colorscheme = "vaporwave",
    },
    {
      name = "VSCode Modern",
      colorscheme = "vscode_modern",
    },
    {
      name = "Wild Charm",
      colorscheme = "wildcharm",
    },
    {
      name = "Xoria",
      colorscheme = "xoria",
    },
    {
      name = "Zaibatsu",
      colorscheme = "zaibatsu",
    },
  },

  -- Preview themes while navigating the menu.
  livePreview = true,
})

-- Open the theme picker with Space+u+t.
vim.keymap.set("n", "<leader>ut", "<cmd>Themery<CR>", {
  desc = "Choose theme",
})
