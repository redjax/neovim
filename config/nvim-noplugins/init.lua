-- Use native package path separator
local sep = package.config:sub(1, 1)

-- Load your main config module (config/init.lua) for all shared config
require("config")

-- Load Neovide-specific config if running in Neovide
--   https://neovide.dev
if vim.g.neovide then
  local neovide_config_path = nvim_shared_path .. sep .. "neovide"
  if vim.fn.isdirectory(neovide_config_path) == 1 then
    -- Protected call to require neovide init.lua inside that directory
    local ok, _ = pcall(require, "neovide.init")
    if not ok then
      vim.notify("Failed to load Neovide config", vim.log.levels.WARN)
    end
  end
end