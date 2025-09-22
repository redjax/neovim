return {
  -- Gruvbox (already added in your colorscheme.lua)
  { "ellisonleao/gruvbox.nvim" },
  
  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
      light_style = "day",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
      sidebars = { "qf", "help" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
  },
  
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = true,
      },
    },
  },
  
  -- One Dark
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "dark", -- dark, darker, cool, deep, warm, warmer, light
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
      lualine = {
        transparent = false,
      },
    },
  },
  
  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      theme = "wave", -- Load "wave" theme when 'background' option is not set
      background = {
        dark = "wave", -- try "dragon" !
        light = "lotus",
      },
    },
  },
  
  -- Nord
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false
    end,
  },
  
  -- Dracula
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = {
      colors = {},
      show_end_of_buffer = true,
      transparent_bg = false,
      lualine_bg_color = "#44475a",
      italic_comment = true,
    },
  },
  
  -- Nightfly
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
    config = function()
      vim.g.nightflyTransparent = false
      vim.g.nightflyUndercurls = true
      vim.g.nightflyUnderlineMatchParen = true
      vim.g.nightflyVirtualTextColor = true
    end,
  },
  
  -- Palenight
  {
    "drewtempelmeyer/palenight.vim",
    priority = 1000,
    config = function()
      vim.g.palenight_terminal_italics = 1
    end,
  },

  -- Oxocarbon
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    config = function()
      vim.opt.background = "dark" -- set this to dark or light
    end,
  },
}