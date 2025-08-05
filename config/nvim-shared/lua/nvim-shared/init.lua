-- Detect platform
local platform = require("nvim-shared.config.platform")
-- Create config object
local config = require("nvim-shared.config")

-- If running in Neovide GUI, set neovide configuration
if vim.g.neovide then
  local ok, neovide_config = pcall(require, "nvim-shared.neovide.init")
  if not ok then
    vim.notify("Failed to load Neovide config: " .. tostring(neovide_config), vim.log.levels.WARN)
  end
end

return {
  platform = platform,
  config = config,
}
