-- On save, strip trailing whitespace and ensure single newline at EOF
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*", -- apply to all files
  callback = function()
    -- Only run for normal, editable file buffers.
    if vim.bo.buftype ~= "" or not vim.bo.modifiable then
      return
    end

    -- Save current cursor position
    local pos = vim.api.nvim_win_get_cursor(0)

    -- Strip trailing whitespace on all lines
    vim.cmd([[ %s/\s\+$//e ]])

    -- Remove any number of blank lines at the end
    vim.cmd([[ %s/\n\+\%$//e ]])

    -- Restore cursor position, clamped to current buffer bounds.
    local line_count = vim.api.nvim_buf_line_count(0)
    local row = math.min(math.max(pos[1], 1), line_count)
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
    local col = math.min(math.max(pos[2], 0), #line)
    vim.api.nvim_win_set_cursor(0, { row, col })
  end,
})
