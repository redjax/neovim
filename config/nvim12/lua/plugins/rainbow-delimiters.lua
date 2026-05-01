-- Rainbow Delimiters https://github.com/HiPhish/rainbow-delimiters.nvim

return {
  src = "https://github.com/HiPhish/rainbow-delimiters.nvim",
  name = "rainbow-delimiters.nvim",

  setup = function()
    local rainbow = require("rainbow-delimiters")
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow.strategy["global"],
      },
      query = {
        [""] = "rainbow-delimiters",
      },
      condition = function(bufnr)
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
        return ok and parser ~= nil
      end,
    }
  end,
}
