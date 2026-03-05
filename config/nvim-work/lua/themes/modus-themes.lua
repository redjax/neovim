-- Modus themes https://github.com/miikanissi/modus-themes.nvim

return {
    "miikanissi/modus-themes.nvim",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    config = function()
      require("modus-themes").setup({
        variant = "auto",
        transparent = false,
        dim_inactive = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
      })
    end,
}
