-- LazyVim configuration and imports
-- This file ensures proper import order as required by LazyVim

return {
  -- Note: lazyvim.plugins is imported in lua/config/lazy.lua
  -- We only need to import extras here, in the correct order
  
  -- Import LazyVim extras 
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  
  -- Configure LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = nil, -- Let Themery manage the colorscheme
    },
  },
}