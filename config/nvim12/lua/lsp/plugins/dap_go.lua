-- Go-specific DAP configuration and Delve integration
-- https://github.com/leoluz/nvim-dap-go

return {
  src = "https://github.com/leoluz/nvim-dap-go",
  name = "nvim-dap-go",

  setup = function()
    require("dap-go").setup()
  end,
}
