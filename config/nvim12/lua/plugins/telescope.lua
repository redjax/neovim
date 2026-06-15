-- Telescope https://github.com/nvim-telescope/telescope.nvim

return {
  src = "https://github.com/nvim-telescope/telescope.nvim",
  name = "telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>pf", desc = "Find files" },
    { "<C-p>", desc = "Git files" },
    { "<leader>ps", desc = "Live grep" },
    { "<leader>pws", desc = "Search word" },
    { "<leader>pWs", desc = "Search WORD" },
    { "<leader>vh", desc = "Help tags" },
  },
  lazy = true,
  setup = function()
    require("telescope").setup({})

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>pws", function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)

    vim.keymap.set("n", "<leader>pWs", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)

    vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
  end,
}
