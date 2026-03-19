-- Precognition https://github.com/tris203/precognition.nvim

return {
  "tris203/precognition.nvim",
  event = "VeryLazy",
  opts = {},
  cmd = { "Precognition" },
  keys = {
    { "<leader>Pp", function()
        local state = require("precognition").toggle()
        if state then
          vim.notify("Precognition ON")
        else
          vim.notify("Precognition OFF")
        end
      end, desc = "Toggle Precognition" },
    { "<leader>PP", function()
        require("precognition").peek()
      end, desc = "Peek Precognition" },
  },
}
