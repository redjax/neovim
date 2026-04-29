local M = {}

-- Get listed buffers
local function listed_buffers()
  local bufs = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted then
      table.insert(bufs, bufnr)
    end
  end

  return bufs
end

-- Show/hide bufferline depending on buffer count
local function update_tabline_visibility()
  local count = #listed_buffers()

  if count <= 1 then
    vim.o.showtabline = 0
  else
    vim.o.showtabline = 2
  end
end

-- Get buffer display name
local function buf_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  if name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(name, ":t")
end

-- Close buffer safely
local function close_buf(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local bufs = listed_buffers()

  -- If it's the last buffer, create a new empty one first
  if #bufs <= 1 then
    vim.cmd("enew")
    vim.api.nvim_buf_delete(bufnr, {
      force = true
    })
    return
  end

  local cur = vim.api.nvim_get_current_buf()

  -- If closing the current buffer, switch first
  if cur == bufnr then
    for _, b in ipairs(bufs) do
      if b ~= bufnr then
        vim.api.nvim_set_current_buf(b)
        break
      end
    end
  end

  vim.api.nvim_buf_delete(bufnr, {
    force = false
  })
end

-- Click handlers (scheduled to avoid E565)
function _G.BufferLineClick(minwid, clicks, button, mods)
  if minwid <= 0 then
    return
  end

  if button == "l" then
    vim.schedule(function()
      vim.api.nvim_set_current_buf(minwid)
    end)
  elseif button == "r" then
    vim.schedule(function()
      close_buf(minwid)
    end)
  end
end

function _G.BufferLineClose(minwid, clicks, button, mods)
  if button == "l" and minwid > 0 then
    vim.schedule(function()
      close_buf(minwid)
    end)
  end
end

-- Tabline renderer
function _G.BufferLine()
  local bufs = listed_buffers()

  if #bufs <= 1 then
    return ""
  end

  local curbuf = vim.api.nvim_get_current_buf()
  local parts = {}

  for i, bufnr in ipairs(bufs) do
    local name = buf_name(bufnr)

    -- Highlight
    table.insert(parts, bufnr == curbuf and "%#TabLineSel#" or "%#TabLine#")

    -- Clickable name
    table.insert(parts, "%" .. bufnr .. "@v:lua.BufferLineClick@")
    table.insert(parts, " " .. name .. " ")
    table.insert(parts, "%T")

    -- Close button
    table.insert(parts, "%#TabLineFill#")
    table.insert(parts, "%" .. bufnr .. "@v:lua.BufferLineClose@")
    table.insert(parts, "x")
    table.insert(parts, "%X")

    -- Divider
    if i < #bufs then
      table.insert(parts, " | ")
    end
  end

  table.insert(parts, "%#TabLineFill#%T")

  return table.concat(parts)
end

function M.setup()
  vim.o.tabline = "%!v:lua.BufferLine()"

  -- Create augroup (prevents duplicates on reload)
  local group = vim.api.nvim_create_augroup("BufferLineAutoHide", {
    clear = true
  })

  vim.api.nvim_create_autocmd({"BufAdd", "BufDelete", "BufEnter"}, {
    group = group,
    callback = function()
      vim.schedule(update_tabline_visibility)
    end
  })

  -- Initial state
  update_tabline_visibility()
end

return M
