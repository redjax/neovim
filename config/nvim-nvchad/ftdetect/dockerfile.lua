-- Dockerfile filetype detection
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
