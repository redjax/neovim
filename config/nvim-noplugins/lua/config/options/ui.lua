-- Show line numbers
vim.opt.number = true
-- Show relative line numbers
vim.opt.relativenumber = false

-- Show buffers as tabs
--   0: hidden, 1: visibile only when 2+ tabs, 2: always visible
--   If you use a plugin like tabby, keep this at 0
vim.opt.showtabline = 2
vim.opt.tabpagemax = 100

-- Import custom bufferline
require("config.options.bufferline").setup()

-- Mouse support
vim.opt.mouse = "a"

-- UI tweaks
vim.opt.cursorline = true
-- vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Display invisible characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Show live preview of things like search & replace
vim.opt.inccommand = 'split'

-- Dark/light mode
vim.opt.background = 'dark'
