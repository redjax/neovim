-- DevOps and CI/CD support for Azure DevOps and GitHub Actions
-- Includes specialized configurations for pipeline files

return {
  -- YAML LSP with DevOps-specific schemas (already covered in lsp-comprehensive.lua)
  
  -- GitHub Actions syntax highlighting and validation
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "yaml",
        "dockerfile",
        "bash",
        "json",
      })
      return opts
    end,
  },
  
  -- File type detection for DevOps files
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        filename = {
          ["azure-pipelines.yml"] = "yaml.azure-pipelines",
          ["azure-pipelines.yaml"] = "yaml.azure-pipelines",
          [".azure-pipelines.yml"] = "yaml.azure-pipelines",
          [".azure-pipelines.yaml"] = "yaml.azure-pipelines",
        },
        pattern = {
          -- Azure DevOps pipeline files
          [".*/%.azure/pipelines/.*%.ya?ml"] = "yaml.azure-pipelines",
          [".*/pipelines/.*%.ya?ml"] = "yaml.azure-pipelines",
          
          -- GitHub Actions workflow files
          [".*/.github/workflows/.*%.ya?ml"] = "yaml.github-workflow",
          
          -- GitHub Action definition files
          [".*/action%.ya?ml"] = "yaml.github-action",
          
          -- Docker compose files
          [".*/docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
          [".*/compose%.ya?ml"] = "yaml.docker-compose",
        },
      })
    end,
  },
  
  -- DevOps-specific keymaps and settings
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Azure DevOps pipeline settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "yaml.azure-pipelines" },
        callback = function()
          vim.opt_local.commentstring = "# %s"
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          
          -- Azure DevOps specific keymaps
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>ap", ":!az pipelines run --name %:t:r<CR>", 
            vim.tbl_extend("force", opts, { desc = "Run Azure Pipeline" }))
        end,
      })
      
      -- GitHub Actions workflow settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "yaml.github-workflow" },
        callback = function()
          vim.opt_local.commentstring = "# %s"
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          
          -- GitHub Actions specific keymaps
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>ga", ":!gh workflow run %:t<CR>", 
            vim.tbl_extend("force", opts, { desc = "Run GitHub Action" }))
        end,
      })
      
      -- Docker Compose settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "yaml.docker-compose" },
        callback = function()
          vim.opt_local.commentstring = "# %s"
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          
          -- Docker Compose specific keymaps
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>dc", ":!docker-compose up -d<CR>", 
            vim.tbl_extend("force", opts, { desc = "Docker Compose Up" }))
          vim.keymap.set("n", "<leader>dd", ":!docker-compose down<CR>", 
            vim.tbl_extend("force", opts, { desc = "Docker Compose Down" }))
        end,
      })
    end,
  },
  
  -- Linting for GitHub Actions and Azure DevOps
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "actionlint",      -- GitHub Actions linter
        "yamllint",        -- YAML linter
      })
      return opts
    end,
  },
  
  -- Null-ls integration for DevOps linting
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        -- GitHub Actions linting
        nls.builtins.diagnostics.actionlint.with({
          filetypes = { "yaml.github-workflow" },
        }),
        -- YAML linting
        nls.builtins.diagnostics.yamllint.with({
          filetypes = { "yaml", "yaml.azure-pipelines", "yaml.github-workflow", "yaml.docker-compose" },
        }),
      })
      return opts
    end,
  },
}