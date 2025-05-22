-- None-ls https://github.com/nvimtools/none-ls.nvim

return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- Manage sources
                -- \ https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md

                -- Misc
                null_ls.builtins.hover.dictionary,
                null_ls.builtins.hover.printenv,

                -- Formatters
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.treefmt,

                -- Linters
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.formatting.stylelint,

                -- Code actions
                null_ls.builtins.code_actions.gitsigns,

                -- Treesitter
                null_ls.builtins.code_actions.ts_node_action,

                -- Luasnip
                null_ls.builtins.completion.luasnip,

                -- Nvim snippets
                null_ls.builtins.completion.nvim_snippets,

                -- Spelling suggestions
                null_ls.builtins.completion.spell,
                null_ls.builtins.diagnostics.codespell,

                -- Github Actions checks
                null_ls.builtins.diagnostics.actionlint,

                -- Bash
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.shellharden,

                -- Markdown
                null_ls.builtins.diagnostics.alex,
                null_ls.builtins.diagnostics.markdownlint,
                null_ls.builtins.diagnostics.markdownlint_cli2,
                null_ls.builtins.diagnostics.textlint,
                null_ls.builtins.formatting.mdformat,
                null_ls.builtins.formatting.remark,
                null_ls.builtins.formatting.textlint,

                -- Ansible
                null_ls.builtins.diagnostics.ansiblelint,

                -- Django
                null_ls.builtins.diagnostics.djlint,
                null_ls.builtins.formatting.djhtml,

                -- .env
                null_ls.builtins.diagnostics.dotenv_linter,

                -- Go
                null_ls.builtins.code_actions.gomodifytags,
                null_ls.builtins.diagnostics.golangci_lint,
                null_ls.builtins.diagnostics.staticcheck,
                null_ls.builtins.formatting.gofmt,
                null_ls.builtins.formatting.goimports,
                null_ls.builtins.formatting.goimports_reviser,
                null_ls.builtins.formatting.golines,

                -- Python
                null_ls.builtins.diagnostics.pylint.with({
                    diagnostics_postprocess = function(diagnostic)
                        diagnostic.code = diagnostic.message_id
                    end,
                }),
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.black,
                -- null_ls.builtins.formatting.blackd,
                null_ls.builtins.formatting.pyink,

                -- Nix
                null_ls.builtins.diagnostics.statix,
                null_ls.builtins.diagnostics.deadnix,
                null_ls.builtins.formatting.alejandra,
                null_ls.builtins.formatting.nixfmt,
                null_ls.builtins.formatting.nixpkgs_fmt,
                null_ls.builtins.formatting.nix_flake_fmt,

                -- Git commit messages
                null_ls.builtins.diagnostics.gitlint,

                -- Hashicorp HCL
                null_ls.builtins.formatting.hclfmt,

                -- Opentofu
                null_ls.builtins.diagnostics.opentofu_validate,
                null_ls.builtins.formatting.opentofu_fmt,

                -- Terraform
                null_ls.builtins.diagnostics.terraform_validate,
                null_ls.builtins.diagnostics.terragrunt_validate,
                null_ls.builtins.diagnostics.tfsec,
                null_ls.builtins.formatting.terraform_fmt,
                null_ls.builtins.formatting.terragrunt_fmt,

                -- English prose
                null_ls.builtins.diagnostics.proselint,
                null_ls.builtins.diagnostics.vale,
                null_ls.builtins.diagnostics.write_good,

                -- Salt
                null_ls.builtins.diagnostics.saltlint,

                -- JSON
                null_ls.builtins.diagnostics.spectral,

                -- YAML
                null_ls.builtins.diagnostics.yamllint,
                null_ls.builtins.formatting.yamlfix,
                null_ls.builtins.formatting.yamlfmt,

                -- SQL
                null_ls.builtins.diagnostics.sqruff,
                null_ls.builtins.formatting.pg_format,
                null_ls.builtins.formatting.sqlfmt,
                null_ls.builtins.formatting.sqlformat,
                null_ls.builtins.formatting.sql_formatter,

                -- CSS
                null_ls.builtins.diagnostics.stylelint,

                -- HTML
                null_ls.builtins.diagnostics.tidy,
                null_ls.builtins.formatting.htmlbeautifier,

                -- XML
                null_ls.builtins.formatting.xmllint,

                -- C#
                null_ls.builtins.formatting.csharpier,

                -- NGINX
                null_ls.builtins.formatting.nginx_beautifier,

                -- NodeJS
                null_ls.builtins.formatting.npm_groovy_lint,
            }
        })
    end,
}
