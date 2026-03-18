-- Rainbow Delimiters https://github.com/HiPhish/rainbow-delimiters.nvim

return {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
        local rainbow = require("rainbow-delimiters")
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow.strategy["global"],
            },
            query = {
                [""] = "rainbow-delimiters",
            },
            -- Skip buffers that don't have a treesitter parser
            condition = function(bufnr)
                local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
                return ok and parser ~= nil
            end,
        }
    end,
}
