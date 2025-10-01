-- Conform.nvim - Lightweight yet powerful formatter plugin
-- https://github.com/stevearc/conform.nvim

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  config = function()
    require("conform").setup({
      -- Map of filetype to formatters
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },
        
        -- Python
        python = { "isort", "black" },
        
        -- JavaScript/TypeScript
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        
        -- Web technologies
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        yml = { "prettier" },
        markdown = { "prettier" },
        
        -- Go
        go = { "gofumpt", "goimports" },
        
        -- Rust
        rust = { "rustfmt" },
        
        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        
        -- PowerShell
        ps1 = { "powershell_es" },
        psm1 = { "powershell_es" },
        
        -- Terraform
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        
        -- SQL
        sql = { "sqlfmt" },
        
        -- Docker
        dockerfile = { "dockerls" },
        
        -- C/C++
        c = { "clang_format" },
        cpp = { "clang_format" },
        
        -- XML
        xml = { "xmllint" },
      },
      
      -- Custom formatters
      formatters = {
        powershell_es = {
          command = "pwsh",
          args = { "-Command", "Format-Document" },
          stdin = true,
        },
      },
      
      -- Format on save configuration
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        
        -- Disable for certain filetypes
        local disable_filetypes = { "sql", "terraform" }
        if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      
      -- Format after save for async formatters
      format_after_save = {
        lsp_format = "fallback",
      },
      
      -- Log level for debugging
      log_level = vim.log.levels.WARN,
      
      -- Notify on error
      notify_on_error = true,
    })
    
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    
    -- Add commands to toggle autoformat
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}