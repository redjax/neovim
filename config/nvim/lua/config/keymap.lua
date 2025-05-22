-- Set leader key (optional, recommended)
vim.g.mapleader = " " -- Space as leader

-- Save file with <leader>w
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save file' })

-- Copy to system clipboard
vim.keymap.set({'n', 'x'}, 'gy', '"+y', { desc = 'Copy to clipboard' })

-- Paste from system clipboard
vim.keymap.set({'n', 'x'}, 'gp', '"+p', { desc = 'Paste from clipboard' })

-- Delete without affecting registers
vim.keymap.set({'n', 'x'}, 'x', '"_x', { desc = 'Delete without yank' })
vim.keymap.set({'n', 'x'}, 'X', '"_d', { desc = 'Delete line without yank' })

-- Select all
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>', { desc = 'Select all' })
