-- Enable true color support
vim.o.termguicolors = true

-- Set window size
vim.o.columns  = 24
vim.o.lines = 10

-- Set the font for Neovide (adjust to your preferred font and size)
vim.o.guifont = "FiraCode Nerd Font:h14"

-- Neovide transparency settings
vim.g.neovide_transparency = 0.8

-- Cursor animation settings for Neovide
vim.g.neovide_cursor_animation_length = 0.12
vim.g.neovide_cursor_trail_size = 0.8

-- Enable cursor effects
vim.g.neovide_cursor_animate_in_insert_mode = true

-- Disable Neovide splash screen for faster start
vim.g.neovide_no_idle = true

-- Set Neovide refresh rate
vim.g.neovide_refresh_rate = 60

-- Custom Neovide window padding
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
