-- Penumbra theme https://github.com/Allianaab2m/penumbra.nvim

return {
    enabled = true,
    "Allianaab2m/penumbra.nvim",
    name = "penumbra",
    lazy = false,
    priority = 1000,
    opts = {
        -- Example options (uncomment and adjust as desired)
        -- italic_comment = true,
        -- transparent_bg = false,
        -- show_end_of_buffer = false,
        -- lualine_bg_color = "#282828",
        -- light = false,
        -- contrast = "plus", -- or "plusplus"
        -- colors = { red = "#FF0000" }, -- customize colors
        -- overrides = { NonText = { fg = "#888888" } },
    },
    config = function(_, opts)
        require("penumbra").setup(opts or {})
    end,
}
