-- Precognition https://github.com/tris203/precognition.nvim

return {
  src = "https://github.com/tris203/precognition.nvim",
  name = "precognition.nvim",
  setup = function()
    local precognition = require("precognition")

    precognition.setup({
      startVisible = true,
    })

    vim.keymap.set("n", "<leader>Pp", function()
      local state = precognition.toggle()
      if state then
        vim.notify("Precognition ON")
      else
        vim.notify("Precognition OFF")
      end
    end, { desc = "Toggle Precognition" })

    vim.keymap.set("n", "<leader>PP", function()
      precognition.peek()
    end, { desc = "Peek Precognition" })
  end,
}
