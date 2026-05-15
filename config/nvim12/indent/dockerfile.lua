-- Dockerfile indent function (2 spaces for continuation lines)

function _G.DockerfileIndent()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)

  local prevlnum = vim.fn.prevnonblank(lnum - 1)
  if prevlnum == 0 then
    return 0
  end

  local prevline = vim.fn.getline(prevlnum)
  local prev_indent = vim.fn.indent(prevlnum)

  if line:match("^%s*[A-Z][A-Z]+%s") or line:match("^%s*[A-Z][A-Z]+$") then
    return 0
  end

  if prevline:match("\\%s*$") then
    if prev_indent > 0 then
      return prev_indent
    end
    return 2
  end

  return 0
end

return 0
