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
  opts = function(_, opts)
    local function has(cmd)
      return vim.fn.executable(cmd) == 1
    end

    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Lua
    opts.formatters_by_ft.lua = { "stylua" }

    -- Python
    if has("isort") or has("black") then
      opts.formatters_by_ft.python = { "isort", "black" }
    end

    -- JavaScript/TypeScript (only if prettier is available)
    if has("prettier") or has("prettierd") then
      local prettier = has("prettierd") and "prettierd" or "prettier"
      opts.formatters_by_ft.javascript = { prettier }
      opts.formatters_by_ft.typescript = { prettier }
      opts.formatters_by_ft.javascriptreact = { prettier }
      opts.formatters_by_ft.typescriptreact = { prettier }
      opts.formatters_by_ft.html = { prettier }
      opts.formatters_by_ft.css = { prettier }
      opts.formatters_by_ft.scss = { prettier }
      opts.formatters_by_ft.json = { prettier }
      opts.formatters_by_ft.jsonc = { prettier }
      opts.formatters_by_ft.yaml = { prettier }
      opts.formatters_by_ft.yml = { prettier }
      opts.formatters_by_ft.markdown = { prettier }
    end

    -- Rust
    if has("rustfmt") then
      opts.formatters_by_ft.rust = { "rustfmt" }
    end

    -- Shell
    if has("shfmt") then
      opts.formatters_by_ft.sh = { "shfmt" }
      opts.formatters_by_ft.bash = { "shfmt" }
      opts.formatters_by_ft.zsh = { "shfmt" }
    end

    -- PowerShell
    if has("pwsh") then
      opts.formatters_by_ft.ps1 = { "powershell_es" }
      opts.formatters_by_ft.psm1 = { "powershell_es" }
      opts.formatters = opts.formatters or {}
      opts.formatters.powershell_es = {
        command = "pwsh",
        args = { "-Command", "Format-Document" },
        stdin = true,
      }
    end

    -- Terraform
    if has("terraform") then
      opts.formatters_by_ft.terraform = { "terraform_fmt" }
      opts.formatters_by_ft.tf = { "terraform_fmt" }
    end

    -- SQL
    if has("sqlfmt") then
      opts.formatters_by_ft.sql = { "sqlfmt" }
    end

    -- C/C++
    if has("clang-format") then
      opts.formatters_by_ft.c = { "clang_format" }
      opts.formatters_by_ft.cpp = { "clang_format" }
    end

    -- XML
    if has("xmllint") then
      opts.formatters_by_ft.xml = { "xmllint" }
    end

    -- Log level for debugging
    opts.log_level = vim.log.levels.WARN

    -- Notify on error
    opts.notify_on_error = true

    return opts
  end,
  init = function()
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