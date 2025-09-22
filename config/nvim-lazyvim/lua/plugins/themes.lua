return {
  -- Aura
  {
    "daltonmenezes/aura-theme",
    name = "aura-theme",
    lazy = false,
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    end
  },

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

  -- Eldritch
  {
    "eldritch-theme/eldritch.nvim",
    name = "eldritch",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("eldritch").setup({
          -- palette = "default", -- This option is deprecated. Use `vim.cmd[[colorscheme eldritch-dark]]` instead.
          transparent = false, -- Enable this to disable setting the background color
          terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
          styles = {
              -- Style to be applied to different syntax groups
              -- Value is any valid attr-list value for `:help nvim_set_hl`
              comments = { italic = true },
              keywords = { italic = true },
              functions = {},
              variables = {},
              -- Background styles. Can be "dark", "transparent" or "normal"
              sidebars = "dark", -- style for sidebars, see below
              floats = "dark", -- style for floating windows
          },
          sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
          hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
          dim_inactive = false, -- dims inactive windows, transparent must be false for this to work
          lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
  
          --- You can override specific color groups to use other groups or a hex color
          --- function will be called with a ColorScheme table
          ---@param colors ColorScheme
          on_colors = function(colors) end,
  
          --- You can override specific highlights to use other groups or a hex color
          --- function will be called with a Highlights and ColorScheme table
          ---@param highlights Highlights
          ---@param colors ColorScheme
          on_highlights = function(highlights, colors) end,
          })
    end
  },
  
  -- One Dark
--   {
--     "navarasu/onedark.nvim",
--     priority = 1000,
--     opts = {
--       style = "dark", -- dark, darker, cool, deep, warm, warmer, light
--       transparent = false,
--       term_colors = true,
--       ending_tildes = false,
--       cmp_itemkind_reverse = false,
--       code_style = {
--         comments = "italic",
--         keywords = "none",
--         functions = "none",
--         strings = "none",
--         variables = "none",
--       },
--       lualine = {
--         transparent = false,
--       },
--     },
--   },
  {
    "olimorris/onedarkpro.nvim",
    name = "onedarkpro",
    lazy = false,
    priority = 1000,
  },

  -- One Monokai
  {
    "cpea2506/one_monokai.nvim",
    name = "one_monokai",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        require("one_monokai").setup({
            transparent = false,
            colors = {},
            highlights = function(colors)
                return {}
            end,
            italics = true,
        })
    end
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

  -- Neko-Night
  {
    "neko-night/nvim",
    priority = 1000,
    lazy = false,
    config = function()
    end,
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

  -- VSCode Modern
  {
    "gmr458/vscode_modern_theme.nvim",
    name = "vscode_modern",
    lazy = false,
    priority = 1000,
    config = function()
        require("vscode_modern").setup({
            cursorline = true,
            transparent_background = false,
            nvim_tree_darker = true,
        })
    end,
  }
}