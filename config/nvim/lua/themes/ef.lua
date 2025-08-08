-- Ef themes https://github.com/oonamo/ef-themes.nvim

return {
    "oonamo/ef-themes.nvim",
    name = "ef",
    lazy = false,
    priority = 1000,
    config = function()
        require("ef-themes").setup({
        light = "ef-spring",
        dark = "ef-winter",
        transparent = false,
        styles = {
            comments = { italic = true },
            keywords = { bold = true },
            functions = {},
            variables = {},
            classes = { bold = true },
            types = { bold = true },
            diagnostic = "default",
            pickers = "default",
        },
        modules = {
            blink = true,
            fzf = false,
            mini = true,
            semantic_tokens = false,
            snacks = false,
            treesitter = true,
        },
        on_colors = function(colors, name) end,
        on_highlights = function(highlights, colors, name)
        -- Example: return { Normal = { fg = colors.fg_alt, bg = colors.bg_inactive } }
      end,
      options = {
        compile = true,
        compile_path = vim.fn.stdpath("cache") .. "/ef-themes",
      },
    })
  end,
}
