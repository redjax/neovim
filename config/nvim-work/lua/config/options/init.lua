-- Clipboard settings
require('config.options.clipboard')
-- Encoding settings
require('config.options.encoding')
-- Folding settings
require('config.options.folding')
-- GUI settings
require('config.options.gui')
-- Indentation settings
require('config.options.indent')
-- Search settings
require('config.options.search')
-- State settings
require('config.options.state')
-- Terminal settings
require('config.options.terminal')
-- UI settings
require('config.options.ui')
-- Window settings
require('config.options.window')
-- Whitespace trimming & newline on save
require('config.options.whitespace')
-- Autocmds for LSP and filetype-specific behavior
require('config.options.autocmds')

-- Performance optimizations
vim.opt.updatetime = 250       -- Faster completion and CursorHold events
vim.opt.timeoutlen = 300       -- Time to wait for mapped sequence
vim.opt.synmaxcol = 300        -- Max column for syntax highlight

-- Disable unnecessary providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
