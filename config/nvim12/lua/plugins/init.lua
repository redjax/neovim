local M = {}

local function is_disabled(path)
  return path:find("plugins/disabled/") ~= nil
end

local function is_plugin_loader(path)
  return path:match("/lua/plugins/init%.lua$") ~= nil
end

local function file_to_module(path)
  return path
    :match("lua/(.+)")
    :gsub("%.lua$", "")
    :gsub("/", ".")
end

local function list_plugins()
  local result = {}

  for _, pattern in ipairs({
    "lua/plugins/*.lua",
    "lua/plugins/**/*.lua",
  }) do

    -- all=true is required here; false returns only the first matching file.
    for _, path in ipairs(vim.api.nvim_get_runtime_file(pattern, true)) do
      if not is_disabled(path) and not is_plugin_loader(path) then
        table.insert(result, path)
      end
    end

  end

  local seen, unique = {}, {}
  
  for _, path in ipairs(result) do
    if not seen[path] then
      seen[path] = true
      table.insert(unique, path)
    end
  end

  table.sort(unique)

  return unique
end

function M.setup()
  local paths = list_plugins()

  -- Load all plugins (this will run vim.pack.add inside each file)
  for _, path in ipairs(paths) do
    local mod = file_to_module(path)
    local ok, plugin = pcall(require, mod)

    if not ok then
      vim.notify("Failed to load plugin file: " .. path .. ": " .. plugin, vim.log.levels.ERROR)
    end
  end

  -- Run plugin setups
  for _, path in ipairs(paths) do
    local mod = file_to_module(path)
    local ok, plugin = pcall(require, mod)

    if ok and plugin and plugin.setup then
      plugin.setup()
    end
  end
end

M.setup()

