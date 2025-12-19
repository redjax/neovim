-- LazyVim configuration and imports
-- This file ensures proper import order as required by LazyVim
-- NOTE: Language extras are already lazy-loaded by filetype automatically
-- They won't slow down startup - they only load when you open files of that type

return {
  -- Note: lazyvim.plugins is imported in lua/config/lazy.lua
  -- We only need to import extras here, in the correct order
  
  -- Import LazyVim language extras
  -- These lazy-load automatically when you open files of the respective type
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  
  -- Import LazyVim tool extras
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
  
  -- Configure LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = nil, -- Let Themery manage the colorscheme
    },
  },
}