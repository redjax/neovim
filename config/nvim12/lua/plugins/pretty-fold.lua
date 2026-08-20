-- Pretty fold https://github.com/anuvyklack/pretty-fold.nvim

return {
  src = "https://github.com/anuvyklack/pretty-fold.nvim",
  name = "pretty-fold.nvim",

  setup = function()
    require("pretty-fold").setup()

    -- Filetype‑specific setup for C#
    require("pretty-fold").ft_setup("cs", {
      process_comment_signs = false,
      comment_signs = {
        "/**",
        "//",
      },
      matchup_patterns = {
        { "{", "}" },
      },
    })
  end,
}
