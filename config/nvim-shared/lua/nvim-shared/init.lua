-- Detect platform
local platform = require("nvim-shared.config.platform")
-- Create config object
local config = require("nvim-shared.config")
-- Create LSP object
local lsp = require("nvim-shared.lsp")

return {
  platform = platform,
  config = config,
  lsp = lsp,
}
