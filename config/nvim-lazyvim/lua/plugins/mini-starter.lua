return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VimEnter",
    config = function()
      require("mini.starter").setup()
    end,
  },
}
