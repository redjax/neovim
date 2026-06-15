-- Load platform detection first (required by other modules)
require("config.platform")

-- Disable netrw early so nvim-tree can be loaded on demand without races.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymap")
