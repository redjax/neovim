-- Docker and Docker Compose LSP support
-- Includes Dockerfile LSP, Docker Compose YAML support, and linting (no custom keybindings)

return {
  -- Dockerfile LSP
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      
      -- Dockerfile Language Server
      opts.servers.dockerls = {
        filetypes = { "dockerfile" },
        settings = {
          docker = {
            languageserver = {
              formatter = {
                ignoreMultilineInstructions = true,
              },
            },
          },
        },
      }
      
      return opts
    end,
  },
  
  -- Docker tools via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- Docker tools
      vim.list_extend(opts.ensure_installed, {
        "dockerfile-language-server", -- Dockerfile LSP
        "hadolint",                   -- Dockerfile linter
      })
      
      return opts
    end,
  },
  
  -- Enhanced treesitter support for Docker files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "dockerfile",
      })
      return opts
    end,
  },
  
  -- File type detection for Docker files
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        filename = {
          ["Dockerfile"] = "dockerfile",
          ["dockerfile"] = "dockerfile",
          ["Containerfile"] = "dockerfile",
          ["containerfile"] = "dockerfile",
          ["docker-compose.yml"] = "yaml.docker-compose",
          ["docker-compose.yaml"] = "yaml.docker-compose",
          ["compose.yml"] = "yaml.docker-compose",
          ["compose.yaml"] = "yaml.docker-compose",
        },
        pattern = {
          -- Dockerfile variants
          [".*/Dockerfile.*"] = "dockerfile",
          [".*/dockerfile.*"] = "dockerfile",
          [".*/Containerfile.*"] = "dockerfile",
          [".*/containerfile.*"] = "dockerfile",
          
          -- Docker Compose variants
          [".*/docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
          [".*/compose.*%.ya?ml"] = "yaml.docker-compose",
          [".*%-compose%.ya?ml"] = "yaml.docker-compose",
          [".*/docker/compose.*%.ya?ml"] = "yaml.docker-compose",
        },
      })
    end,
  },
  
  -- Docker-specific settings (no keymaps)
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Dockerfile settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dockerfile" },
        callback = function()
          vim.opt_local.commentstring = "# %s"
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.expandtab = true
        end,
      })
      
      -- Docker Compose settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "yaml.docker-compose" },
        callback = function()
          vim.opt_local.commentstring = "# %s"
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.expandtab = true
        end,
      })
    end,
  },
  
  -- Linting integration for Docker files
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        -- Dockerfile linting
        nls.builtins.diagnostics.hadolint.with({
          filetypes = { "dockerfile" },
        }),
      })
      return opts
    end,
  },
  
  -- Enhanced completion for Docker files
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Docker-specific completion sources
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dockerfile" },
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "buffer" },
              { name = "path" },
            }),
          })
        end,
      })
      
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "yaml.docker-compose" },
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "buffer" },
              { name = "path" },
            }),
          })
        end,
      })
    end,
  },
}