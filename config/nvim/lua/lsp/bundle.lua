return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      -- "hrsh7th/nvim-cmp",
      -- "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "j-hui/fidget.nvim",
      "ray-x/lsp_signature.nvim",
      -- optionally add none-ls here as a dependency too
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local lsp_auto_servers = require("lsp.lsp-auto-servers")
      local ensure_installed = lsp_auto_servers.get and lsp_auto_servers.get() or {}

      -- Call your core setup function with the dynamic server list
      require("lsp.core").setup(ensure_installed)

      -- Load and apply enhanced server configurations
      local server_configs = lsp_auto_servers.load_server_configs()
      
      -- Apply enhanced configurations for specific servers using modern vim.lsp.config API
      for server_name, config in pairs(server_configs) do
        if config.settings then
          -- Find the actual LSP server names for this configuration
          if config.servers then
            for _, server in ipairs(config.servers) do
              if vim.tbl_contains(ensure_installed, server) then
                vim.lsp.config[server] = {
                  settings = config.settings[server] or config.settings,
                  filetypes = config.filetypes,
                  root_dir = vim.fs.root,
                  single_file_support = true,
                }
              end
            end
          end
        end
      end

      -- Setup signature if present
      local signature = require("lsp.plugins.signature")
      if signature.config then
        if type(signature.config) == "function" then
          signature.config()  -- call it directly
        elseif type(signature.config) == "table" then
          require("lsp_signature").setup(signature.config)
        end
      end

      -- Setup none-ls if present
      local none_ls = require("lsp.plugins.none_ls")
      if none_ls.config then
        none_ls.config()
      end
    end,
  }
}
