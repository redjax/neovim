-- Mason integration for DAP adapters
-- https://github.com/jay-babu/mason-nvim-dap.nvim

return {
  src = "https://github.com/jay-babu/mason-nvim-dap.nvim",
  name = "mason-nvim-dap.nvim",

  setup = function()
    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
    })
  end,
}
