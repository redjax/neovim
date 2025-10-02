-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load Neovide-specific config if running in Neovide
--   https://neovide.dev
if vim.g.neovide then
  -- Protected call to require neovide init.lua
  local ok, _ = pcall(require, "neovide.init")
  if not ok then
    vim.notify("Failed to load Neovide config", vim.log.levels.WARN)
  end
end
