-- None-ls as a discrete plugin, extended to include mason-null-ls integration with dynamic tooling detection
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "jay-babu/mason-null-ls.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
      },
      config = function()
        local function has(tool)
          return vim.fn.executable(tool) == 1
        end

        -- Dynamically build ensure_installed based on available executables
        local ensure_installed = {
          -- Tools that generally don't depend on external executables (or assumed always available)
          "stylua",
          "prettier",
          "eslint_d",
        }

        if has("python3") then
          -- table.insert(ensure_installed, "black")
        end

        if has("go") then
          table.insert(ensure_installed, "golangci_lint")
          -- add other go-based tools if used
        end

        if has("npm") or has("node") then
          -- You can add any npm/node tools here if needed
        end

        if has("cargo") then
          -- For Rust or cargo tools, add them here if in use
        end

        if has("nix") then
          -- Add nix tools if applicable, omit any problematic ones (e.g., nix_flake_fmt) if you want
          -- table.insert(ensure_installed, "alejandra")  -- for example
        end

        -- You can add other tools conditionally similarly

        require("mason-null-ls").setup({
          ensure_installed = ensure_installed,
          automatic_setup = true,
          automatic_installation = true,
        })
      end,
    },
  },
  config = function()
    local null_ls = require("null-ls")
    local builtins = null_ls.builtins
    local sources = {}

    local function has(tool)
      return vim.fn.executable(tool) == 1
    end

    -- Always-include sources (no external binary required or always useful)
    local always_sources = {
      builtins.hover.dictionary,
      builtins.hover.printenv,

      -- Completion/snippets/spelling
      builtins.completion.luasnip,
      builtins.completion.nvim_snippets,
      builtins.completion.spell,

      -- GitHub Actions diagnostics
      builtins.diagnostics.actionlint,
    }
    vim.list_extend(sources, always_sources)

    -- Go-related sources
    if has("go") then
      vim.list_extend(sources, {
        builtins.code_actions.gomodifytags,
        builtins.diagnostics.golangci_lint,
        builtins.diagnostics.staticcheck,
        builtins.formatting.gofmt,
        builtins.formatting.goimports,
        builtins.formatting.goimports_reviser,
        builtins.formatting.golines,
      })
    end

    -- Python-related sources
    if has("python3") then
      vim.list_extend(sources, {
        builtins.formatting.isort,
        builtins.formatting.black,
        builtins.formatting.pyink,
      })
    end

    -- npm/node-related sources
    if has("npm") or has("node") then
      vim.list_extend(sources, {
        builtins.formatting.prettier,
        builtins.formatting.stylelint,
        builtins.diagnostics.eslint_d,
      })
    end

    -- cargo-related sources
    if has("cargo") then
      vim.list_extend(sources, {
        builtins.formatting.stylua,
      })
    end

    -- nix-related sources, omit nix_flake_fmt if problematic
    if has("nix") then
      vim.list_extend(sources, {
        builtins.diagnostics.statix,
        builtins.diagnostics.deadnix,
        builtins.formatting.alejandra,
        builtins.formatting.nixfmt,
        builtins.formatting.nixpkgs_fmt,
        -- builtins.formatting.nix_flake_fmt, -- omit if errors
      })
    end

    -- Shell formatting
    if has("shfmt") then
      table.insert(sources, builtins.formatting.shfmt)
    end

    if has("shellharden") then
      table.insert(sources, builtins.formatting.shellharden)
    end

    -- Markdown (putting these unconditionally for convenience, add gating if you want)
    vim.list_extend(sources, {
      builtins.diagnostics.alex,
      builtins.diagnostics.markdownlint,
      builtins.diagnostics.markdownlint_cli2,
      builtins.diagnostics.textlint,
      builtins.formatting.mdformat,
      builtins.formatting.remark,
      builtins.formatting.textlint,
    })

    -- Other conditionally loaded sources, using your earlier snippet:

    if has("ansible-lint") or has("ansible") then
      table.insert(sources, builtins.diagnostics.ansiblelint)
    end

    if has("djlint") then
      table.insert(sources, builtins.diagnostics.djlint)
      table.insert(sources, builtins.formatting.djhtml)
    end

    if has("terraform") or has("terragrunt") then
      table.insert(sources, builtins.diagnostics.terraform_validate)
      table.insert(sources, builtins.diagnostics.terragrunt_validate)
      table.insert(sources, builtins.formatting.terraform_fmt)
      table.insert(sources, builtins.formatting.terragrunt_fmt)
    end

    if has("git") then
      table.insert(sources, builtins.diagnostics.gitlint)
    end

    if has("hclfmt") then
      table.insert(sources, builtins.formatting.hclfmt)
    end

    if has("proselint") then
      table.insert(sources, builtins.diagnostics.proselint)
    end

    if has("write-good") then
      table.insert(sources, builtins.diagnostics.write_good)
    end

    if has("salt-lint") then
      table.insert(sources, builtins.diagnostics.saltlint)
    end

    if has("spectral") then
      table.insert(sources, builtins.diagnostics.spectral)
    end

    if has("yamllint") then
      table.insert(sources, builtins.diagnostics.yamllint)
      table.insert(sources, builtins.formatting.yamlfix)
      table.insert(sources, builtins.formatting.yamlfmt)
    end

    if has("sqrl") or has("sqlfluff") or has("sqlformat") then
      table.insert(sources, builtins.diagnostics.sqruff)
      table.insert(sources, builtins.formatting.pg_format)
      table.insert(sources, builtins.formatting.sqlfmt)
      table.insert(sources, builtins.formatting.sqlformat)
      table.insert(sources, builtins.formatting.sql_formatter)
    end

    if has("stylelint") then
      table.insert(sources, builtins.diagnostics.stylelint)
    end

    if has("tidy") then
      table.insert(sources, builtins.diagnostics.tidy)
    end

    if has("htmlbeautifier") then
      table.insert(sources, builtins.formatting.htmlbeautifier)
    end

    if has("xmllint") then
      table.insert(sources, builtins.formatting.xmllint)
    end

    if has("csharpier") then
      table.insert(sources, builtins.formatting.csharpier)
    end

    if has("nginx-beautifier") then
      table.insert(sources, builtins.formatting.nginx_beautifier)
    end

    if has("npm_groovy_lint") then
      table.insert(sources, builtins.formatting.npm_groovy_lint)
    end

    null_ls.setup({
      sources = sources,
      -- you can add other configs here, e.g., on_attach, debounce, etc.
    })
  end,
}
