-- Set window size
vim.g.neovide_remember_window_size = true

vim.o.columns  = 80
vim.o.lines = 24

vim.g.neovide_scale_factor = 1.0

-- Neovide transparency settings
vim.g.neovide_opacity = 1.0

-- Disable Neovide splash screen for faster start
vim.g.neovide_no_idle = true

-- Set Neovide refresh rate
vim.g.neovide_refresh_rate = 60
-- Only redraw when needed (default for performance)
vim.g.neovide_no_idle = false
vim.g.neovide_refresh_rate_idle = 5    

-- Custom Neovide window padding
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
