-- Enable true color support
vim.o.termguicolors = true

-- Automatically switch background for light/dark theme (auto, dark, light)
vim.g.neovide_theme = 'auto'

vim.g.neovide_input_use_logo = true          -- Use "logo" key as a modifier (for custom keybinds)
vim.g.neovide_profiler = false               -- Enable profiler/debug statistics

-- Set window size
vim.g.neovide_remember_window_size = true
vim.o.columns  = 80
vim.o.lines = 24
vim.g.neovide_scale_factor = 1.0

-- Set the font for Neovide (adjust to your preferred font and size)
vim.o.guifont = "FiraCode Nerd Font:h12"

-- Neovide transparency settings
vim.g.neovide_opacity = 0.8

-- Cursor animation settings for Neovide
vim.g.neovide_cursor_animation_length = 0.15
vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_vfx_mode = "wireframe"    -- Other options: "railgun", "torpedo", "particle", "sonicboom"
vim.g.neovide_cursor_vfx_particle_density = 10

-- Enable cursor effects
vim.g.neovide_cursor_animate_in_insert_mode = true

-- Disable Neovide splash screen for faster start
vim.g.neovide_no_idle = true

-- Set Neovide refresh rate
vim.g.neovide_refresh_rate = 60
vim.g.neovide_no_idle = false            -- Only redraw when needed (default for performance)
vim.g.neovide_refresh_rate_idle = 5      -- Refresh rate when application is unfocused

-- Custom Neovide window padding
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
