-- Sort https://github.com/sQVe/sort.nvim

return {
  "sQVe/sort.nvim",
  cmd = "Sort",
  keys = {
    { "go", desc = "Sort operator" },
    { "go", desc = "Sort selection", mode = "v" },
  },
  config = function()
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
