-- Whitespace policy:
-- 1) Strip trailing spaces on save.
-- 2) Keep a final newline for all filetypes by default.
-- 3) Allow explicit filetype opt-outs (e.g. json/jsonc).

local whitespace_group = vim.api.nvim_create_augroup("whitespace_rules", { clear = true })

local no_final_newline_by_ft = {
  json = true,
  jsonc = true,
}

vim.opt.fixeol = true

vim.api.nvim_create_autocmd("FileType", {
  group = whitespace_group,
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    vim.bo[bufnr].fixeol = not no_final_newline_by_ft[ft]
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = whitespace_group,
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then return end

    local ft = vim.bo[bufnr].filetype
    local should_add_final_newline = not no_final_newline_by_ft[ft]

    -- Re-apply newline policy at write-time in case another plugin changed it.
    vim.bo[bufnr].fixeol = should_add_final_newline
    vim.bo[bufnr].endofline = should_add_final_newline

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd([[silent! keeppatterns %s/\s\+$//e]])
    end)

    if should_add_final_newline then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      if #lines > 0 and lines[#lines] ~= "" then table.insert(lines, "") end
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end

    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = whitespace_group,
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then return end

    local ft = vim.bo[bufnr].filetype
    local should_add_final_newline = not no_final_newline_by_ft[ft]
    if not should_add_final_newline then return end

    if vim.b[bufnr]._whitespace_fixing_eof then return end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if #lines == 0 or lines[#lines] == "" then return end

    local view = vim.fn.winsaveview()
    vim.b[bufnr]._whitespace_fixing_eof = true
    table.insert(lines, "")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd([[silent noautocmd keepalt update]])
    end)
    vim.b[bufnr]._whitespace_fixing_eof = false
    vim.fn.winrestview(view)
  end,
})
