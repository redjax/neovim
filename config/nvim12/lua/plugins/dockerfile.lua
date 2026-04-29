-- Dockerfile enhanced support
-- Syntax: https://github.com/ekalinin/Dockerfile.vim

return {
  -- Required: plugin git source URL.
  src = "https://github.com/ekalinin/Dockerfile.vim",
  name = "dockerfile.vim",
  setup = function()
    -- Disable the plugin's indentation before it loads.
    vim.g.dockerfile_indent = 0
    vim.g.dockerfile_enable_indent = 0

    -- Ensure proper filetype detection for Dockerfile names.
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = {
        "Dockerfile*",
        "*.Dockerfile",
        "*.dockerfile",
        "*dockerfile",
        "Containerfile*",
        "*.Containerfile",
        "*.containerfile",
      },
      callback = function()
        vim.bo.filetype = "dockerfile"
      end,
    })

    -- Catch any file whose name contains "dockerfile" case‑insensitively.
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      callback = function()
        local filename = vim.fn.expand("%:t"):lower()
        if filename:match("dockerfile") then
          vim.bo.filetype = "dockerfile"
        end
      end,
    })

    -- Dockerfile‑specific settings.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dockerfile",
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        vim.bo.autoindent = false
        vim.bo.smartindent = false
        vim.bo.cindent = false
        vim.bo.indentexpr = "v:lua.DockerfileIndent()"

        -- Force settings after buffer is fully loaded to override plugin.
        vim.schedule(function()
          vim.bo.shiftwidth = 2
          vim.bo.tabstop = 2
          vim.bo.softtabstop = 2
          vim.bo.autoindent = false
          vim.bo.smartindent = false
          vim.bo.cindent = false
          vim.bo.indentexpr = "v:lua.DockerfileIndent()"
        end)

        vim.b.autoformat = true

        local opts = { buffer = true, silent = true }

        -- Indent: tab = 2 spaces
        vim.keymap.set("i", "<Tab>", function()
          return string.rep(" ", vim.bo.shiftwidth)
        end, { buffer = true, expr = true, desc = "Insert 2 spaces" })

        -- Format Dockerfile
        vim.keymap.set("n", "<leader>df", function()
          require("conform").format({ async = true, lsp_format = "never" })
        end, vim.tbl_extend("force", opts, { desc = "Format Dockerfile" }))

        -- Hover info
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover info" }))

        -- Float diagnostics
        vim.keymap.set("n", "<leader>dl", function()
          vim.diagnostic.open_float()
        end, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))

        -- Manual lint
        vim.keymap.set("n", "<leader>dL", function()
          require("lint").try_lint()
          vim.notify("Linting triggered for " .. vim.bo.filetype, vim.log.levels.INFO)
        end, vim.tbl_extend("force", opts, { desc = "Manual lint" }))

        -- LSP info
        vim.keymap.set("n", "<leader>di", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP Info" }))

        -- Lint info (list configured linters for filetype)
        vim.keymap.set("n", "<leader>dI", function()
          local lint = require("lint")
          local linters = lint.linters_by_ft[vim.bo.filetype] or {}
          if #linters == 0 then
            vim.notify("No linters for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
          else
            vim.notify("Linters for " .. vim.bo.filetype .. ": " .. table.concat(linters, ", "), vim.log.levels.INFO)
          end
        end, vim.tbl_extend("force", opts, { desc = "Lint Info" }))
      end,
    })
  end,
}
