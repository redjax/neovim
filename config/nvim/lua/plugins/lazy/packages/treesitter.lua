-- Treesitter https://github.com/nvim-treesitter/nvim-treesitter

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- Add languages supported by Treesitter
            --   https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
            ensure_installed = {
                "bash",
                "bicep",
                "c_sharp",
                "caddy",
                "cmake",
                "comment",
                "commonlisp",
                "css",
                "csv",
                "diff",
                "dockerfile",
                "editorconfig",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "gotmpl",
                "gowork",
                "gpg",
                "graphql",
                "hcl",
                "html",
                "http",
                "ini",
                "javascript",
                "jinja",
                "json",
                "kusto",
                "lua",
                "luadoc",
                "markdown",
                "nginx",
                "nix",
                "php",
                "powershell",
                "properties",
                "python",
                "regex",
                "robots",
                "rust",
                "scss",
                "sql",
                "ssh_config",
                "superhtml",
                "svelte",
                "terraform",
                "tmux",
                "toml",
                "typescript",
                "vue",
                "xml",
                "yaml",
            },
            sync_install = false,
            auto_install = true,
            indent = { enable = true },
            highlight = {
                enable = true,
                -- Enable vim regex highlighting alongside treesitter
                additional_vim_regex_highlighting = true,
            },
        })
  
        -- Add the custom templ parser
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
        }
        -- Register templ parser
        vim.treesitter.language.register("templ", "templ")

    end
}
  