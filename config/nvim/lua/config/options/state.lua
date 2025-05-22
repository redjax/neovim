-- Backup, swap, undo
vim.opt.swapfile = false
vim.opt.backup = false

if vim.g.platform == "windows" then
    vim.opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
else
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.undofile = true

-- Time in ms after typing stops before executing CursorHold events
vim.opt.updatetime = 250
