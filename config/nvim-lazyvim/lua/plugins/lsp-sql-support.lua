-- SQL support for PostgreSQL, MySQL, and Microsoft SQL Server
-- Includes LSP, formatting, and database-specific configurations

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      
      -- SQL Language Server
      opts.servers.sqlls = {
        filetypes = { "sql", "mysql", "pgsql", "plsql" },
        settings = {
          sqlLanguageServer = {
            connections = {
              -- Add your database connections here
              -- Example for PostgreSQL:
              -- {
              --   name = "postgres_local",
              --   adapter = "postgresql",
              --   host = "localhost",
              --   port = 5432,
              --   user = "postgres",
              --   database = "mydb"
              -- }
            },
          },
        },
      }
      
      return opts
    end,
  },
  
  -- SQL formatter and linter
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "sqlls",           -- SQL Language Server
        "sqlfluff",        -- SQL linter and formatter
        "sql-formatter",   -- SQL formatter
      })
      return opts
    end,
  },
  
  -- SQL syntax highlighting and file type detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "sql",
      })
      return opts
    end,
  },
  
  -- SQL file type associations
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- File type associations
      vim.filetype.add({
        extension = {
          sql = "sql",
          pgsql = "pgsql",
          mysql = "mysql",
          psql = "pgsql",
        },
        pattern = {
          [".*%.sql"] = "sql",
          [".*%.pgsql"] = "pgsql", 
          [".*%.mysql"] = "mysql",
          [".*%.psql"] = "pgsql",
        },
      })
    end,
  },
  
  -- Formatting configuration for SQL
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.sql = { "sqlfluff" }
      opts.formatters_by_ft.mysql = { "sqlfluff" }
      opts.formatters_by_ft.pgsql = { "sqlfluff" }
      return opts
    end,
  },
  
  -- SQL keymaps and settings
  {
    "LazyVim/LazyVim",
    opts = function()
      -- SQL-specific settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "pgsql" },
        callback = function()
          -- Set SQL-specific options
          vim.opt_local.commentstring = "-- %s"
          vim.opt_local.iskeyword:append("@-@")
          
          -- SQL-specific keymaps
          local opts = { buffer = true, silent = true }
          vim.keymap.set("n", "<leader>sf", ":!sqlfluff format %<CR>", 
            vim.tbl_extend("force", opts, { desc = "Format SQL file" }))
        end,
      })
    end,
  },
}