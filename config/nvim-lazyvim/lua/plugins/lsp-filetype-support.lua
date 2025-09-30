-- Additional file type support and treesitter configurations
-- Ensures all mentioned languages have proper syntax highlighting and parsing

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- Ensure all required parsers are installed
      vim.list_extend(opts.ensure_installed, {
        -- Core languages
        "lua",
        "vim",
        "vimdoc",
        "query",
        
        -- Programming languages
        "python",
        "go",
        "rust", 
        "c",
        "cpp",
        "javascript",
        "typescript",
        "tsx",
        
        -- Shell scripting
        "bash",
        
        -- Configuration and data formats
        "yaml",
        "json",
        "toml",
        "ini",
        "csv",
        
        -- Infrastructure as Code
        "terraform",
        "hcl",
        "dockerfile",
        
        -- Documentation
        "markdown",
        "markdown_inline",
        "rst",
        
        -- Database
        "sql",
        
        -- Web technologies
        "html",
        "css",
        "scss",
        
        -- Version control
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "gitattributes",
        
        -- Other useful formats
        "regex",
        "http",
        "diff",
      })
      
      -- Enhanced treesitter configuration
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false
      
      opts.indent = opts.indent or {}
      opts.indent.enable = true
      
      opts.incremental_selection = opts.incremental_selection or {}
      opts.incremental_selection.enable = true
      opts.incremental_selection.keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      }
      
      return opts
    end,
  },
  
  -- Additional file type associations
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        extension = {
          -- Infrastructure as Code
          tf = "terraform",
          tfvars = "terraform",
          bicep = "bicep",
          
          -- Shell scripts
          ps1 = "ps1",
          psm1 = "ps1",
          psd1 = "ps1",
          
          -- Configuration files
          conf = "conf",
          env = "sh",
          
          -- Data files
          csv = "csv",
          tsv = "csv",
          
          -- SQL variants
          pgsql = "sql",
          mysql = "sql",
          
          -- YAML variants
          yml = "yaml",
          yaml = "yaml",
        },
        filename = {
          -- Configuration files
          [".env"] = "sh",
          [".env.local"] = "sh",
          [".env.development"] = "sh",
          [".env.production"] = "sh",
          
          -- Docker files
          ["Dockerfile"] = "dockerfile",
          ["dockerfile"] = "dockerfile",
          
          -- CI/CD files
          [".gitlab-ci.yml"] = "yaml",
          ["Jenkinsfile"] = "groovy",
        },
        pattern = {
          -- Environment files
          ["%.env%..*"] = "sh",
          
          -- Terraform files
          [".*%.tf"] = "terraform",
          [".*%.tfvars"] = "terraform",
          
          -- Docker files
          [".*/Dockerfile.*"] = "dockerfile",
          
          -- Shell scripts without extension
          [".*"] = {
            function(path, buf)
              local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
              if first_line:match("^#!/.*sh") or first_line:match("^#!/bin/bash") then
                return "bash"
              elseif first_line:match("^#!/.*pwsh") or first_line:match("^#!/.*powershell") then
                return "ps1"
              elseif first_line:match("^#!/.*python") then
                return "python"
              end
            end,
          },
        },
      })
    end,
  },
  
  -- Enhanced folding with treesitter
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)
      
      -- Set fold settings
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      
      -- Fold keymaps
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    end,
  },
}