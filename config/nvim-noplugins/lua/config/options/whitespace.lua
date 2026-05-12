-- On save, strip trailing whitespace and ensure single newline at EOF
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*", -- apply to all files
  callback = function()
    -- Save current cursor position
    local pos = vim.api.nvim_win_get_cursor(0)

    -- Strip trailing whitespace on all lines
    vim.cmd([[ %s/\s\+$//e ]])

    -- Remove any number of blank lines at the end
    vim.cmd([[ %s/\n\+\%$//e ]])

    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})
