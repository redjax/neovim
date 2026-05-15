-- Theme plugin catalog for nvim12 + vim.pack.

return {
  { src = "https://github.com/rktjmp/lush.nvim", name = "lush.nvim" },
  {
    src = "https://github.com/daltonmenezes/aura-theme",
    name = "aura-theme",
    setup = function(spec)
      local aura_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. spec.name .. "/packages/neovim"
      vim.opt.rtp:append(aura_path)
    end,
  },
  {
    src = "https://github.com/Shatur/neovim-ayu",
    name = "ayu",
    setup = function()
      vim.g.ayu_style = "ayu-dark"
    end,
  },
  {
    src = "https://github.com/uloco/bluloco.nvim",
    name = "bluloco.nvim",
    setup = function()
      require("bluloco").setup({
        style = "dark",
        transparent = false,
        italics = false,
        terminal = vim.fn.has("gui_running") == 1,
        guicursor = true,
      })
    end,
  },
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/Mofiqul/dracula.nvim", name = "dracula" },
  {
    src = "https://github.com/sainnhe/edge",
    name = "edge",
    setup = function()
      vim.g.edge_style = "aura"
    end,
  },
  {
    src = "https://github.com/oonamo/ef-themes.nvim",
    name = "ef",
    setup = function()
      local cache_dir = vim.fn.stdpath("cache")
      vim.fn.mkdir(cache_dir, "p")

      require("ef-themes").setup({
        light = "ef-spring",
        dark = "ef-winter",
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
          functions = {},
          variables = {},
          classes = { bold = true },
          types = { bold = true },
          diagnostic = "default",
          pickers = "default",
        },
        modules = {
          blink = true,
          fzf = false,
          mini = true,
          semantic_tokens = false,
          snacks = false,
          treesitter = true,
        },
        on_colors = function() end,
        on_highlights = function() end,
        options = {
          compile = true,
          compile_path = cache_dir .. "/ef-themes",
        },
      })
    end,
  },
  {
    src = "https://github.com/eldritch-theme/eldritch.nvim",
    name = "eldritch",
    setup = function()
      require("eldritch").setup({
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = true,
        on_colors = function() end,
        on_highlights = function() end,
      })
    end,
  },
  {
    src = "https://github.com/lancewilhelm/horizon-extended.nvim",
    name = "horizon-extended",
    setup = function()
      vim.g.horizon_style = "neo"
    end,
  },
  {
    src = "https://github.com/rebelot/kanagawa.nvim",
    name = "kanagawa",
    setup = function()
      require("kanagawa").setup({
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
        overrides = function()
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },
  { src = "https://github.com/kevinm6/kurayami.nvim", name = "kurayami.nvim" },
  {
    src = "https://github.com/miikanissi/modus-themes.nvim",
    name = "modus-themes.nvim",
    setup = function()
      require("modus-themes").setup({
        transparent = false,
        dim_inactive = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
      })
    end,
  },
  { src = "https://github.com/tanvirtin/monokai.nvim", name = "monokai" },
  { src = "https://github.com/bluz71/vim-moonfly-colors", name = "vim-moonfly-colors" },
  { src = "https://github.com/neko-night/nvim", name = "neko-knight" },
  { src = "https://github.com/bluz71/vim-nightfly-colors", name = "nightfly" },
  {
    src = "https://github.com/EdenEast/nightfox.nvim",
    name = "nightfox.nvim",
    setup = function()
      require("nightfox").setup({
        options = {
          terminal_colors = false,
        },
      })
    end,
  },
  { src = "https://github.com/shaunsingh/nord.nvim", name = "nord" },
  { src = "https://github.com/AlexvZyl/nordic.nvim", name = "nordic" },
  {
    src = "https://github.com/navarasu/onedark.nvim",
    name = "onedark",
    setup = function()
      require("onedark").setup({
        style = "darker",
      })
    end,
  },
  { src = "https://github.com/olimorris/onedarkpro.nvim", name = "onedarkpro" },
  {
    src = "https://github.com/cpea2506/one_monokai.nvim",
    name = "one_monokai",
    setup = function()
      require("one_monokai").setup({
        transparent = false,
        colors = {},
        highlights = function()
          return {}
        end,
        italics = true,
      })
    end,
  },
  { src = "https://github.com/nyoom-engineering/oxocarbon.nvim", name = "oxocarbon" },
  { src = "https://github.com/JoosepAlviste/palenightfall.nvim", name = "palenightfall" },
  { src = "https://github.com/NLKNguyen/papercolor-theme", name = "papercolor" },
  {
    src = "https://github.com/Allianaab2m/penumbra.nvim",
    name = "penumbra",
    setup = function()
      require("penumbra").setup({})
    end,
  },
  {
    src = "https://github.com/olivercederborg/poimandres.nvim",
    name = "poimandres.nvim",
    setup = function()
      require("poimandres").setup({
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,
      })
    end,
  },
  { src = "https://github.com/armannikoyan/rusty", name = "rusty" },
  { src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight" },
  {
    src = "https://github.com/vague-theme/vague.nvim",
    name = "vague.nvim",
    setup = function()
      require("vague").setup()
    end,
  },
  {
    src = "https://github.com/gmr458/vscode_modern_theme.nvim",
    name = "vscode_modern",
    setup = function()
      require("vscode_modern").setup({
        cursorline = true,
        transparent_background = false,
        nvim_tree_darker = true,
      })
    end,
  },
  { src = "https://github.com/jnurmine/Zenburn", name = "zenburn" },
  { src = "https://github.com/titanzero/zephyrium", name = "zephyrium" },
  { src = "https://github.com/rockyzhang24/arctic.nvim", name = "arctic" },
}
