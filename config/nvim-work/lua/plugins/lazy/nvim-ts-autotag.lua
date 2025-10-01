-- Automatic HTML/XML tag closing and renaming
-- https://github.com/windwp/nvim-ts-autotag

return {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        "markdown",
        "astro",
        "glimmer",
        "handlebars",
        "hbs",
    },
    config = function()
        require("nvim-ts-autotag").setup({
            opts = {
                -- Defaults
                enable_close = true, -- Auto close tags
                enable_rename = true, -- Auto rename pairs of tags
                enable_close_on_slash = false, -- Auto close on trailing </
            },
            -- File type aliases for tag support
            aliases = {
                ["astro"] = "html",
                ["eruby"] = "html",
                ["vue"] = "html",
                ["htmldjango"] = "html",
            },
        })
    end,
}