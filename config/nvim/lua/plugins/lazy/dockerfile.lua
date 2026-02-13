-- Dockerfile enhanced support
-- Syntax: https://github.com/ekalinin/Dockerfile.vim

return {
  "ekalinin/Dockerfile.vim",
  ft = { "dockerfile" },
  config = function()
    -- Ensure proper filetype detection for various Dockerfile names
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = {
        "Dockerfile*",
        "*.Dockerfile",
        "*.dockerfile",
        "Containerfile*",
        "*.Containerfile",
      },
      callback = function()
        vim.bo.filetype = "dockerfile"
      end,
    })

    -- Dockerfile-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dockerfile",
      callback = function()
        -- Use 4 spaces for indentation (Docker convention)
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
        
        -- Enable format on save for Dockerfiles
        vim.b.autoformat = true
        
        -- Add useful keymaps for Dockerfile editing
        local opts = { buffer = true, silent = true }
        
        -- Format the file
        vim.keymap.set("n", "<leader>df", function()
          vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format Dockerfile" }))
        
        -- Show hover documentation (for instructions like FROM, RUN, etc.)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover info" }))
      end,
    })
  end,
}