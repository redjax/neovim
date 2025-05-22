-- Conflict marker https://github.com/rhysd/conflict-marker.vim

return {
    enabled = true,
    "rhysd/conflict-marker.vim",
    -- Loads the plugin when you open a file
    event = "BufReadPre",
}