-- Treesitter https://github.com/nvim-treesitter/nvim-treesitter

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    priority = 100,
    config = function()
        -- Safely load treesitter config
        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
            return
        end
        
        configs.setup({
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
                "norg",
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
                "vim",
                "vimdoc",
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
  
        -- Register templ filetype (parser installed via ensure_installed or auto_install)
        vim.treesitter.language.register("templ", "templ")

    end
}
