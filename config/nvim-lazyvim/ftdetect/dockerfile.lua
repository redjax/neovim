-- Dockerfile filetype detection
-- This runs early in Neovim's startup to ensure proper filetype setting

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "Dockerfile",
    "Dockerfile.*",
    "*.Dockerfile",
    "*.dockerfile",
    "*dockerfile*",
    "Containerfile",
    "Containerfile.*",
    "*.Containerfile",
    "*.containerfile",
  },
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})

-- Fallback: check filename content for "dockerfile"
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  callback = function()
    local filename = vim.fn.expand("%:t"):lower()
    if filename:match("dockerfile") and vim.bo.filetype == "" then
      vim.bo.filetype = "dockerfile"
    end
  end,
})
