-- Dockerfile enhanced support
-- Syntax: https://github.com/ekalinin/Dockerfile.vim

return {
  "ekalinin/Dockerfile.vim",
  ft = { "dockerfile" },
  init = function()
    -- Completely disable the plugin's indentation before it loads
    vim.g.dockerfile_indent = 0
    vim.g.dockerfile_enable_indent = 0
  end,
  config = function()
    -- Ensure proper filetype detection for various Dockerfile names
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = {
        "Dockerfile*",
        "*.Dockerfile",
        "*.dockerfile",
        "*dockerfile",  -- Match lowercase variations
        "Containerfile*",
        "*.Containerfile",
        "*.containerfile",
      },
      callback = function()
        vim.bo.filetype = "dockerfile"
      end,
    })
    
    -- Additional check for files with 'dockerfile' in the name
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      callback = function()
        local filename = vim.fn.expand("%:t"):lower()
        if filename:match("dockerfile") then
          vim.bo.filetype = "dockerfile"
        end
      end,
    })

    -- Dockerfile-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dockerfile",
      callback = function()
        -- Use 2 spaces for indentation
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        
        -- Disable all automatic indentation except our custom one
        vim.bo.autoindent = false
        vim.bo.smartindent = false
        vim.bo.cindent = false
        
        -- Set up custom indent expression for backslash continuation
        vim.bo.indentexpr = "v:lua.DockerfileIndent()"
        
        -- Force settings after buffer is fully loaded to override plugin
        vim.schedule(function()
          vim.bo.shiftwidth = 2
          vim.bo.tabstop = 2
          vim.bo.softtabstop = 2
          vim.bo.autoindent = false
          vim.bo.smartindent = false
          vim.bo.cindent = false
          vim.bo.indentexpr = "v:lua.DockerfileIndent()"
        end)
        
        -- Enable format on save for Dockerfiles
        vim.b.autoformat = true
        
        -- Add useful keymaps for Dockerfile editing
        local opts = { buffer = true, silent = true }
        
        -- Manual indent/dedent
        vim.keymap.set("i", "<Tab>", function()
          return string.rep(" ", vim.bo.shiftwidth)
        end, { buffer = true, expr = true, desc = "Insert 2 spaces" })
        
        -- Format the file
        vim.keymap.set("n", "<leader>df", function()
          vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format Dockerfile" }))
        
        -- Show hover documentation (for instructions like FROM, RUN, etc.)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover info" }))
        
        -- Show diagnostics
        vim.keymap.set("n", "<leader>dl", function()
          vim.diagnostic.open_float()
        end, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
        
        -- Manually trigger linting
        vim.keymap.set("n", "<leader>dL", function()
          require("lint").try_lint()
          vim.notify("Linting triggered for " .. vim.bo.filetype, vim.log.levels.INFO)
        end, vim.tbl_extend("force", opts, { desc = "Manual lint" }))
        
        -- Check LSP status
        vim.keymap.set("n", "<leader>di", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP Info" }))
        
        -- Check lint status
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