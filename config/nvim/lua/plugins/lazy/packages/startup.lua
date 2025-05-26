-- Startup.nvim https://github.com/max397574/startup.nvim

return {
    enabled = true,
    "startup-nvim/startup.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim"
    },
    config = function()
      -- "dashboard, "evil", "startify", or your custom theme
      require("startup").setup({ theme = "dashboard" })
    end,
}
