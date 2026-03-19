return {
  "hasansujon786/nvim-navbuddy",
  dependencies = {
    "hasansujon786/nvim-navic",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
  },
  event = "LspAttach",
  keys = {
    {
      "<leader>nv",
      function()
        require("nvim-navbuddy").open()
      end,
      desc = "Nav Buddy",
    },
  },
  opts = {
    window = {
      border = "single",
      size = "60%",
      position = "50%",
      sections = {
        left = { size = "20%" },
        mid = { size = "40%" },
        right = { preview = "leaf" },
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
    },
    source_buffer = {
      follow_node = true,
      highlight = true,
      reorient = "smart",
    },
  },
}
