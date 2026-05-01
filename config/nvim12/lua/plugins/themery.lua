-- Themery https://github.com/zaldih/themery.nvim

return {
  src = "https://github.com/zaldih/themery.nvim",
  name = "themery.nvim",
  setup = function()
    local themery = require("themery")
    local menu = require("themes._themery_menu")

    themery.setup({
      themes = menu.themes,
      livePreview = true,
    })

    vim.schedule(function()
      local state_file = vim.fn.stdpath("data") .. "/themery/state.json"
      local persisted

      if vim.fn.filereadable(state_file) == 1 then
        local ok_read, lines = pcall(vim.fn.readfile, state_file)
        if ok_read then
          local ok_decode, data = pcall(vim.json.decode, table.concat(lines, "\n"))
          if ok_decode and type(data) == "table" and type(data.colorscheme) == "string" and data.colorscheme ~= "" then
            persisted = data.colorscheme
          end
        end
      end

      local target = persisted or menu.default
      pcall(vim.cmd.colorscheme, target)
    end)

    vim.keymap.set("n", "<leader>tt", "<cmd>Themery<cr>", { desc = "Open Themery" })
  end,
}
