-- Backup, swap, undo
vim.opt.swapfile = false
vim.opt.backup = false

-- Time in ms after typing stops before executing CursorHold events
vim.opt.updatetime = 250

local undodir
if vim.g.platform == "windows" then
    local userprofile = os.getenv("USERPROFILE")
    if userprofile then
        undodir = userprofile .. "/.vim/undodir"
    else
        vim.notify("USERPROFILE not set! Undo directory not configured.", vim.log.levels.ERROR)
    end
else
    local home = os.getenv("HOME")
    if home then
        undodir = home .. "/.vim/undodir"
    else
        vim.notify("HOME not set! Undo directory not configured.", vim.log.levels.ERROR)
    end
end

if undodir then
    vim.fn.mkdir(undodir, "p")
    vim.opt.undodir = undodir
    vim.opt.undofile = true
end
