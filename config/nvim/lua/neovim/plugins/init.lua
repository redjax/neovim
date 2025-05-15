-- Load Lazy package manager
require("neovim.plugins.pkg_mgr.lazy_init") 

-- Define plugins to import
  -- Easily swap plugins in/out
local enabled_plugins = {
    "neovim.plugins.gitsigns",
    "neovim.plugins.autopairs",
    "neovim.plugins.lint",
    "neovim.plugins.indent_line",
    -- "plugins.mason"
}

-- Create object for lazy setup
local specs = {}

for _, plugin in ipairs(enabled_plugins) do
    table.insert(specs, require(plugin))
end

-- Import plugins with lazy
require("lazy").setup(specs)
