-- Define plugins to import
  -- Easily swap plugins in/out
local enabled_plugins = {
    "plugins.gitsigns",
    "plugins.autopairs",
    "plugins.neo-tree",
    "plugins.lint",
    "plugins.indent_line"
    -- "plugins.mason"
}

-- Create object for lazy setup
local specs = {}

for _, plugin in ipairs(enabled_plugins) do
    table.insert(specs, require(plugin))
end

-- Import plugins with lazy
require("lazy").setup(specs)
