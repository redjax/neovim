-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable LazyVim import order check (we know what we're doing with modular plugins)
vim.g.lazyvim_check_order = false

-- Line numbers: Use absolute numbers instead of relative
vim.opt.number = true          -- Enable line numbers
vim.opt.relativenumber = false -- Disable relative line numbers (LazyVim default is true)

-- Performance optimizations
vim.opt.updatetime = 250       -- Faster completion and CursorHold events (default 4000)
vim.opt.timeoutlen = 300       -- Time to wait for mapped sequence (default 1000)
vim.opt.lazyredraw = false     -- Don't redraw during macros (can cause issues with some plugins)
vim.opt.synmaxcol = 300        -- Max column for syntax highlight (prevents slowdown on long lines)

-- Disable some built-in providers for faster startup
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
