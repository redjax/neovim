-- Sort https://github.com/sQVe/sort.nvim

return {
  "sQVe/sort.nvim",
  config = function()
    require("sort").setup({
      -- Delimiter priority order for automatic detection
      delimiters = { ",", "|", ";", ":", "s", "t" },
      natural_sort = true,      -- Enable natural sorting (number-aware)
      ignore_case = false,      -- Case-sensitive sorting by default
      whitespace = {
        alignment_threshold = 3,
      },
      mappings = {
        operator = "go",         -- Operator mapping (normal mode)
        textobject = {
          inner = "io",          -- Inner text object for sortable region
          around = "ao",         -- Around text object for sortable region
        },
        motion = {
          next_delimiter = "]o", -- Jump to next delimiter
          prev_delimiter = "[o", -- Jump to previous delimiter
        },
      },
    })
  end,
}
