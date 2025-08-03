return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "j-hui/fidget.nvim",
      "ray-x/lsp_signature.nvim",
      -- optionally add none-ls here as a dependency too
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local auto_servers = require("nvim-shared.lsp.auto_servers")
      local ensure_installed = auto_servers.get and auto_servers.get() or {}

      -- Call your core setup function with the dynamic server list
      require("nvim-shared.lsp.core").setup(ensure_installed)

      -- Setup signature if present
      local signature = require("nvim-shared.lsp.plugins.signature")
      if signature.config then
        require("lsp_signature").setup(signature.config)
      end

      -- Setup none-ls if present
      local none_ls = require("nvim-shared.lsp.plugins.none_ls")
      if none_ls.config then
        none_ls.config()
      end
    end,
  }
}
