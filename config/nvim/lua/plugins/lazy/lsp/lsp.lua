-- Language Server Protocol (LSP) https://github.com/neovim/nvim-lspconfig

return {
  enabled = true,
  "neovim/nvim-lspconfig",
  dependencies = {
      -- Add JSON schema support to JSON LSPs
      -- "b0o/schemastore.nvim",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
      "hrsh7th/cmp-nvim-lsp-signature-help",
  },

  opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = { spacing = 4, prefix = "●" },
          severity_sort = true,
      },
      -- Enable this to enable the builtin LSP in the statusline
      status_diagnostics = true,
  },

  config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load();
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          cmp_lsp.default_capabilities()
      )

      require("fidget").setup({})
      require("mason").setup({
          registries = {
              'github:mason-org/mason-registry',
              'github:crashdummyy/mason-registry',
          },
      })

      -- Install language servers
      -- \  Available servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

      -- Table of LSPs to install.
      -- \ Populate dynamically with if vim.fn.executable()
      local ensure_installed = {}

      -- LSPs to always install
      -- table.insert(ensure_installed, "jinja_lsp")
      table.insert(ensure_installed, "lua_ls")
      table.insert(ensure_installed, "marksman")
      table.insert(ensure_installed, "postgres_lsp")
      table.insert(ensure_installed, "powershell_es")
      table.insert(ensure_installed, "superhtml")
      table.insert(ensure_installed, "tflint")

      -- LSPs requiring dotnet
      if vim.fn.executable("dotnet") == 1 then
          -- table.insert(ensure_installed, "csharp_ls")
          table.insert(ensure_installed, "bicep")
      end

      -- LSPs requiring npm
      if vim.fn.executable("npm") == 1 then
          table.insert(ensure_installed, "ansiblels")
          table.insert(ensure_installed, "azure_pipelines_ls")
          table.insert(ensure_installed, "bashls")
          table.insert(ensure_installed, "css_variables")
          table.insert(ensure_installed, "cssls")
          table.insert(ensure_installed, "cssmodules_ls")
          table.insert(ensure_installed, "docker_compose_language_service")
          table.insert(ensure_installed, "dockerls")
          table.insert(ensure_installed, "eslint")
          table.insert(ensure_installed, "gh_actions_ls")
          table.insert(ensure_installed, "html")
          table.insert(ensure_installed, "jsonls")
          table.insert(ensure_installed, "pyright")
          table.insert(ensure_installed, "sqlls")
          table.insert(ensure_installed, "svelte")
        --   table.insert(ensure_installed, "tailwindcss")
          table.insert(ensure_installed, "vue_ls")
          table.insert(ensure_installed, "yamlls")
      end

      -- LSPs requiring cargo
      if vim.fn.executable("cargo") == 1 then
          table.insert(ensure_installed, "gitlab_ci_ls")
          table.insert(ensure_installed, "markdown_oxide")
      end

      -- LSPs requiring go
      if vim.fn.executable("go") == 1 then
          table.insert(ensure_installed, "golangci_lint_ls")
          table.insert(ensure_installed, "gopls")
          -- table.insert(ensure_installed, "nomad_lsp")
          table.insert(ensure_installed, "sqls")
          -- table.insert(ensure_installed, "terraform_ls")
          -- table.insert(ensure_installed, "terraform_lsp")
      end

      -- LSPs requiring Python/pip
      if vim.fn.executable("pip") == 1 then
          -- table.insert(ensure_installed, "nginx_language_server")
          -- table.insert(ensure_installed, "ruff")
          -- table.insert(ensure_installed, "ruff-lsp")
          -- table.insert(ensure_installed, "salt_ls")
          -- table.insert(ensure_installed, "sqruff")
          -- table.insert(ensure_installed, "cmake")
      end
      
      require("mason-lspconfig").setup({
          -- Install language servers
          -- Available configs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
          ensure_installed = ensure_installed,
          handlers = {
              function(server_name)
                  require("lspconfig")[server_name].setup{
                      capabilities = capabilities
                  }
              end,
              
              ["sqls"] = function()
                  require("lspconfig").sqls.setup{
                      on_attach = function(client, bufnr)
                          require('sqls').on_attach(client, bufnr)
                      end 
                  }
              end,

              ["lua_ls"] = function()
                  require("lspconfig").lua_ls.setup {
                      settings = {
                          Lua = {
                              diagnostics = { globals = { "vim" } },
                              workspace = { checkThirdParty = false },
                          },
                      },
                      capabilities = capabilities,
                  }
              end,

              ["pyright"] = function()
                  require("lspconfig").pyright.setup {
                      settings = {
                          python = {
                              analysis = {
                                  -- "off", "basic", or "strict"
                                  typeCheckingMode = "basic",
                              },
                          },
                      },
                      capabilities = capabilities,
                  }
              end,
              
              ["gopls"] = function()
                  require("lspconfig").gopls.setup {
                      settings = {
                          gopls = {
                              analyses = {
                                  unusedparams = true,
                                  shadow = true,
                              },
                              staticcheck = true,
                          },
                      },
                      capabilities = capabilities,
                  }
              end,

              ["yamlls"] = function()
                  require("lspconfig").yamlls.setup {
                      settings = {
                          yaml = {
                              schemas = require('schemastore').yaml.schemas(),
                              validate = true,
                          },
                      },
                      capabilities = capabilities,
                  }
              end,

            --   ["tailwindcss"] = function()
            --     require("lspconfig").tailwindcss.setup {
            --       capabilities = capabilities,
            --       -- Override filetypes, excluding types like Markdown
            --       filetypes = {
            --         "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html",
            --         "edge", "eelixir", "elixir", "ejs", "erb",
            --         "gohtml", "haml", "handlebars", "html", "html-eex",
            --         "heex", "jade", "liquid", "mdx", "mustache",
            --         "css", "less", "postcss", "sass", "scss", "stylus", "sugarss",
            --         "javascript", "javascriptreact", "typescript", "typescriptreact",
            --         "vue", "svelte"
            --       },

            --       root_dir = require("lspconfig.util").root_pattern(
            --         "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json", ".git"
            --       ),
            --   }
          }
      })

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
          snippet = {
              expand = function(args)
                  require('luasnip').lsp_expand(args.body)
              end,
          },
          
          window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          
          -- mapping = cmp.mapping.preset.insert({
          --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          --     ['<CR>'] = cmp.mapping.confirm({ select = true }),
          --     ["<C-Space>"] = cmp.mapping.complete(),
          -- }),
          
          sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'nvim_lsp_signature_help' }
          }, {
              { name = 'buffer' },
          })
      })

      local on_attach = function(client, bufnr)
          local nmap = function(keys, func, desc)
              desc = "LSP: " .. desc
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true })
          end

          nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          nmap("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          nmap("<leader>gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
          -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

          nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      end
  end
}
