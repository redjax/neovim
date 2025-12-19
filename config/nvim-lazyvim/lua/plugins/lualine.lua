return {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",  -- Load when UI is ready, not on VeryLazy
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
}
