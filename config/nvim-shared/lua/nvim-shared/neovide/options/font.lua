-- Set the font for Neovide (adjust to your preferred font and size)
if vim.fn.has("win32") == 1 then
  vim.o.guifont = "Hack Nerd Font Mono:h12"
elseif vim.fn.has("unix") == 1 then
  vim.o.guifont = "FiraCode Nerd Font Mono:h14"
else
  vim.o.guifont = "FiraCode Nerd Font:h12"
end
