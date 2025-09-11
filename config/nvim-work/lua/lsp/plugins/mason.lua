-- Mason plugin: sets up mason and mason-lspconfig. Actual servers to install are passed when core.setup is invoked.
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim" },
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- minimal bootstrap here; core.setup will drive ensure_installed later
    require("mason").setup()
    require("mason-lspconfig").setup()
  end,
}
