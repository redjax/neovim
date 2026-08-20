-- Scrollview https://github.com/dstein64/nvim-scrollview

return {
  src = "https://github.com/dstein64/nvim-scrollview",
  name = "nvim-scrollview.nvim",

  setup = function()
    local opts = {
      -- excluded_filetypes = { "NvimTree", "neo-tree", "alpha" },
      -- current_only = true,
      -- base = "buffer",
      -- column = 80,
      -- signs_on_startup = { "diagnostics", "search" },
    }
    require("scrollview").setup(opts)
  end,
}
