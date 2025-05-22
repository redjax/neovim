-- Backup, swap, undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Time in ms after typing stops before executing CursorHold events
vim.opt.updatetime = 250
