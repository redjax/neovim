-- Detect platform
local platform = require("nvim-shared.config.platform")
-- Create config object
local config = require("nvim-shared.config")

return {
  platform = platform,
  config = config,
}
