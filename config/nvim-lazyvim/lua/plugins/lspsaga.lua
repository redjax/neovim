-- LSPSaga - Enhanced LSP UI and navigation
-- https://github.com/nvimdev/lspsaga.nvim

return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach", -- loads when LSP attaches to a buffer
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional but recommended
    "nvim-tree/nvim-web-devicons"      -- optional for icons
  },
  opts = {
    ui = { 
      border = "rounded",
      title = true,
    },
    symbol_in_winbar = {
      enable = true,
    },
    lightbulb = {
      enable = true,
      enable_in_insert = true,
      sign = true,
      sign_priority = 40,
      virtual_text = true,
    },
    -- Use default keymaps (can be customized later if needed)
  },
}