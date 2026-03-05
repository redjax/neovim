-- Vague theme https://github.com/vague-theme/vague.nvim

return {
    "vague-theme/vague.nvim",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    config = function()
      require("vague").setup()
    end,
}
