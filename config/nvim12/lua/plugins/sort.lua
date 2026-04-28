-- Sort https://github.com/sQVe/sort.nvim

return {
  src = "https://github.com/sQVe/sort.nvim",
  name = "sort.nvim",

  setup = function()
    require("sort").setup({
      delimiters = { ",", "|", ";", ":", "s", "t" },
      natural_sort = true,
      ignore_case = false,
      whitespace = {
        alignment_threshold = 3,
      },
      mappings = {
        operator = "go",
        textobject = {
          inner = "io",
          around = "ao",
        },
        motion = {
          next_delimiter = "]o",
          prev_delimiter = "[o",
        },
      },
    })
  end,
}
