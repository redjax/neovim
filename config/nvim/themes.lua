--
-- [ THEME / COLORSCHEME ]
--

-- Install themes
vim.pack.add({
  -- Tokyo Night colorscheme.
  {
    src = "https://github.com/folke/tokyonight.nvim",
    version = "main",
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

  -- Aura colorscheme.
  {
    src = "https://github.com/daltonmenezes/aura-theme",
    version = "main",
  },

  -- VSCode Modern colorscheme.
  {
    src = "https://github.com/gmr458/vscode_modern_theme.nvim",
    version = "main",
  },

  -- Oxocarbon colorscheme.
  {
    src = "https://github.com/nyoom-engineering/oxocarbon.nvim",
    version = "main",
  },

  -- OneDark Pro colorscheme.
  {
    src = "https://github.com/olimorris/onedarkpro.nvim",
    version = "main",
  },

  -- Eldritch colorscheme.
  {
    src = "https://github.com/eldritch-theme/eldritch.nvim",
    version = "master",
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
      name = "Kanagawa Wave",
      colorscheme = "kanagawa-wave",
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
      name = "Tokyo Night Night",
      colorscheme = "tokyonight-night",
    },
    {
      name = "Tokyo Night Moon",
      colorscheme = "tokyonight-moon",
    },
    {
      name = "Moonfly",
      colorscheme = "moonfly",
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
      name = "Slate",
      colorscheme = "slate",
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
      name = "Zaibatsu",
      colorscheme = "zaibatsu",
    },
    {
      name = "NVCode",
      colorscheme = "nvcode",
    },
    {
      name = "Nord",
      colorscheme = "nord",
    },
    {
      name = "Aurora",
      colorscheme = "aurora",
    },
    {
      name = "Gruvbox",
      colorscheme = "gruvbox",
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
      name = "Xoria",
      colorscheme = "xoria",
    },
  },

  -- Preview themes while navigating the menu.
  livePreview = true,
})

-- Open the theme picker with Space+u+t.
vim.keymap.set("n", "<leader>ut", "<cmd>Themery<CR>", {
  desc = "Choose theme",
})
