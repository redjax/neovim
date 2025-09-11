-- Require local config setup
require("config")

-- Load plugin manager
require("manager")

-- Set your active colorscheme
vim.cmd.colorscheme("kanagawa")

-- Load Neovide-specific config if running in Neovide
--   https://neovide.dev
if vim.g.neovide then
  -- Protected call to require neovide init.lua
  local ok, _ = pcall(require, "neovide.init")
  if not ok then
    vim.notify("Failed to load Neovide config", vim.log.levels.WARN)
  end
end
