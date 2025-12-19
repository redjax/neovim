-- LazyVim configuration and imports
-- This file ensures proper import order as required by LazyVim
-- NOTE: Language extras are already lazy-loaded by filetype automatically
-- They won't slow down startup - they only load when you open files of that type

-- Helper function to check if a command exists
local function has(cmd)
    return vim.fn.executable(cmd) == 1
end

-- Build imports dynamically based on available languages
local imports = {
  -- Note: lazyvim.plugins is imported in lua/config/lazy.lua
  -- We only need to import extras here, in the correct order
  
  -- Import LazyVim language extras
  -- These lazy-load automatically when you open files of the respective type
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
}

-- Conditionally add language-specific imports
if has("node") or has("npm") then
  table.insert(imports, { import = "lazyvim.plugins.extras.lang.typescript" })
end

if has("python") or has("python3") then
  table.insert(imports, { import = "lazyvim.plugins.extras.lang.python" })
end

if has("go") then
  table.insert(imports, { import = "lazyvim.plugins.extras.lang.go" })
end
if has("go") then
  table.insert(imports, { import = "lazyvim.plugins.extras.lang.go" })
end

-- Import LazyVim tool extras (conditional on node/npm for prettier and eslint)
if has("node") or has("npm") then
  table.insert(imports, { import = "lazyvim.plugins.extras.formatting.prettier" })
  table.insert(imports, { import = "lazyvim.plugins.extras.linting.eslint" })
end

-- Configure LazyVim colorscheme
table.insert(imports, {
  "LazyVim/LazyVim",
  opts = {
    colorscheme = nil, -- Let Themery manage the colorscheme
  },
})

return imports