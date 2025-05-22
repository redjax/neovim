-- Terminal colors
if vim.g.platform == "windows" then
  vim.opt.termguicolors = true
end

-- Shell
if vim.g.platform == "windows" then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
end
