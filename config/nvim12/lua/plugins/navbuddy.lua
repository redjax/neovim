-- NavBuddy https://github.com/hasansujon786/nvim-navbuddy

return {
  src = "https://github.com/hasansujon786/nvim-navbuddy",
  name = "nvim-navbuddy.nvim",

  setup = function()
    local navbuddy = require("nvim-navbuddy")
    local actions = require("nvim-navbuddy.actions")

    navbuddy.setup({
      window = {
        border = "single",
        size = "60%",
        position = "50%",
        scrolloff = nil,
        sections = {
          left = {
            size = "20%",
            border = nil,
          },
          mid = {
            size = "40%",
            border = nil,
          },
          right = {
            border = nil,
            preview = "leaf",
          },
        },
      },
      node_markers = {
        enabled = true,
        icons = {
          leaf = "  ",
          leaf_selected = " → ",
          branch = " ",
        },
      },
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      source_buffer = {
        follow_node = true,
        highlight = true,
        reorient = "smart",
        scrolloff = nil,
      },
    })

    vim.keymap.set(
      "n",
      "<leader>nv",
      function()
        navbuddy.open()
      end,
      { desc = "Nav Buddy" }
    )
  end,
}
