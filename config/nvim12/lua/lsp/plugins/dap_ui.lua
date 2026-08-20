-- DAP UI for visualizing debugger state
-- https://github.com/rcarriga/nvim-dap-ui

return {
  src = "https://github.com/rcarriga/nvim-dap-ui",
  name = "nvim-dap-ui",

  setup = function()
    require("dapui").setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.25,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 0.25,
          position = "bottom",
        },
      },
    })
  end,
}
