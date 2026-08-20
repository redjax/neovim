return {
  {
    src = "https://github.com/b0o/schemastore.nvim",
    name = "schemastore.nvim",
  },
  {
    src = "https://github.com/j-hui/fidget.nvim",
    name = "fidget.nvim",
    setup = function()
      require("fidget").setup({})
    end,
  },
  require("lsp.plugins.mason"),
  require("lsp.plugins.mason-tool-installer"),
  require("lsp.plugins.lazydev"),
  require("lsp.plugins.signature"),
  require("lsp.plugins.none_ls"),
  require("lsp.plugins.nvim_nio"),
  require("lsp.plugins.dap_ui"),
  require("lsp.plugins.nvim_dap_virtual_text"),
  require("lsp.plugins.mason_nvim_dap"),
  require("lsp.plugins.dap_go"),
  require("lsp.plugins.dap"),
}
