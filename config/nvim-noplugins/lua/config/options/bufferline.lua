local M = {}

local function listed_buffers()
  local bufs = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted then
      table.insert(bufs, bufnr)
    end
  end
  return bufs
end

local function buf_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[No Name]"
  end
  return vim.fn.fnamemodify(name, ":t")
end

local function close_buf(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local bufs = listed_buffers()
  if #bufs <= 1 then
    vim.cmd("enew")
    vim.api.nvim_buf_delete(bufnr, { force = true })
    return
  end

  local cur = vim.api.nvim_get_current_buf()
  if cur == bufnr then
    for _, b in ipairs(bufs) do
      if b ~= bufnr then
        vim.api.nvim_set_current_buf(b)
        break
      end
    end
  end

  vim.api.nvim_buf_delete(bufnr, { force = false })
end

function _G.BufferLineClick(minwid, clicks, button, mods)
  if minwid <= 0 then
    return
  end

  if button == "l" then
    vim.api.nvim_set_current_buf(minwid)
  elseif button == "r" then
    close_buf(minwid)
  end
end

function _G.BufferLine()
  local bufs = listed_buffers()
  if #bufs <= 1 then
    return ""
  end

  local curbuf = vim.api.nvim_get_current_buf()
  local parts = { "%#TabLineFill#" }

  for _, bufnr in ipairs(bufs) do
    local name = buf_name(bufnr)
    if vim.bo[bufnr].modified then
      name = name .. " +"
    end

    if bufnr == curbuf then
      table.insert(parts, "%#TabLineSel#")
    else
      table.insert(parts, "%#TabLine#")
    end

    table.insert(parts, string.format("%%@v:lua.BufferLineClick@%d %s %%X", bufnr, name))
    table.insert(parts, " ")
  end

  table.insert(parts, "%#TabLineFill#%T")
  return table.concat(parts)
end

function M.setup()
  vim.o.showtabline = 2
  vim.o.tabline = "%!v:lua.BufferLine()"
end

return M
