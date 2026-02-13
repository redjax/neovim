-- Dockerfile indent function (2 spaces for continuation lines)

function _G.DockerfileIndent()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)
  
  -- Get previous non-blank line
  local prevlnum = vim.fn.prevnonblank(lnum - 1)
  if prevlnum == 0 then
    return 0
  end
  
  local prevline = vim.fn.getline(prevlnum)
  local prev_indent = vim.fn.indent(prevlnum)
  
  -- If current line starts with a Dockerfile instruction (uppercase word), no indent
  if line:match('^%s*[A-Z][A-Z]+%s') or line:match('^%s*[A-Z][A-Z]+$') then
    return 0
  end
  
  -- If previous line ends with backslash, this is a continuation
  if prevline:match('\\%s*$') then
    -- If previous line already has indent, keep it (multi-line continuation)
    if prev_indent > 0 then
      return prev_indent
    end
    -- First continuation line, indent exactly 2 spaces (NOT shiftwidth multiples)
    return 2
  end
  
  -- If current line doesn't start with instruction and prev line had no backslash
  -- This shouldn't normally happen, but maintain previous indent or 0
  return 0
end

return 0
