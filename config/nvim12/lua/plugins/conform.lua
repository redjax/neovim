-- Conform.nvim - Lightweight yet powerful formatter plugin
-- https://github.com/stevearc/conform.nvim

return {
  src = "https://github.com/stevearc/conform.nvim",
  name = "conform.nvim",
  setup = function()
    -- Ensure plugin is loaded for commands and functionality
    vim.cmd("packadd conform.nvim")

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        yml = { "prettier" },
        markdown = { "prettier" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        dockerfile = { "dockfmt", "dockerfmt", stop_after_first = true },
        ps1 = { "powershell_es" },
        psm1 = { "powershell_es" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        sql = { "sqlfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        xml = { "xmllint" },
      },
      formatters = {
        dockfmt = {
          command = "dockfmt",
          stdin = true,
          condition = function()
            return vim.fn.executable("dockfmt") == 1
          end,
        },
        dockerfmt = {
          command = "dockerfmt",
          stdin = true,
          condition = function()
            return vim.fn.executable("dockerfmt") == 1
          end,
        },
        powershell_es = {
          command = "pwsh",
          args = { "-Command", "Format-Document" },
          stdin = true,
        },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        local disable_filetypes = { "sql", "terraform" }
        local filetype = vim.bo[bufnr].filetype
        if vim.tbl_contains(disable_filetypes, filetype) then return end

        if filetype == "dockerfile" then
          local has_external = vim.fn.executable("dockfmt") == 1
            or vim.fn.executable("dockerfmt") == 1
          if not has_external then
            -- Keep docker LSP features (diagnostics/completion), but never auto-format via LSP.
            return
          end
          return { timeout_ms = 500, lsp_format = "never" }
        end

        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      log_level = vim.log.levels.WARN,
      notify_on_error = true,
    })

    -- Handle Formatexpr
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- User commands for toggling
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })

    -- Manual Keybinding registration
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer" })
  end,
}
