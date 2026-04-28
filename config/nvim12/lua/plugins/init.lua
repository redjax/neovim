local M = {}
local registry = {}
local loaded = {}
local configured = {}

local function is_disabled(path)
  return path:find("plugins/disabled/") ~= nil or path:find("themes/disabled/") ~= nil
end

local function is_plugin_loader(path)
  return path:match("/lua/plugins/init%.lua$") ~= nil
end

local function is_ignored(path)
  local filename = vim.fs.basename(path)
  return filename:sub(1, 1) == "_"
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
    "lua/themes/*.lua",
    "lua/themes/**/*.lua",
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

local function infer_name(src)
  local name = src:match("([^/]+)$") or src
  return name:gsub("%.git$", "")
end

local function normalize_spec(spec, path)
  if type(spec) ~= "table" then
    error("plugin module must return a table: " .. path)
  end

  if type(spec.src) ~= "string" or spec.src == "" then
    error("plugin spec must define src: " .. path)
  end

  spec.name = spec.name or infer_name(spec.src)

  local normalized = {
    src = spec.src,
    name = spec.name,
    version = spec.version,
  }

  return normalized, spec.setup
end

local function load_plugin(name)
  if loaded[name] then
    return true
  end

  local entry = registry[name]
  if not entry then
    vim.notify("Unknown plugin in registry: " .. name, vim.log.levels.WARN)
    return false
  end

  local ok_add, err_add = pcall(vim.cmd.packadd, name)
  if not ok_add then
    vim.notify("Failed to packadd " .. name .. ": " .. err_add, vim.log.levels.ERROR)
    return false
  end

  loaded[name] = true

  return true
end

local function configure_plugin(name)
  if configured[name] then
    return true
  end

  local entry = registry[name]
  if not entry then
    vim.notify("Unknown plugin in registry: " .. name, vim.log.levels.WARN)
    return false
  end

  if not loaded[name] then
    return false
  end

  if type(entry.setup) == "function" then
    local ok_cfg, err_cfg = pcall(entry.setup, entry.spec)
    if not ok_cfg then
      vim.notify("Failed plugin config for " .. name .. ": " .. err_cfg, vim.log.levels.ERROR)
      return false
    end
  end

  configured[name] = true

  return true
end

local function load_specs(paths)
  local pack_specs = {}

  local function register_one(spec, path)
    local ok_norm, normalized, setup_fn = pcall(normalize_spec, spec, path)

    if not ok_norm then
      vim.notify(normalized, vim.log.levels.ERROR)
      return
    end

    registry[normalized.name] = {
      spec = normalized,
      setup = setup_fn,
    }

    table.insert(pack_specs, {
      src = normalized.src,
      name = normalized.name,
      version = normalized.version,
    })
  end

  for _, path in ipairs(paths) do
    if not is_ignored(path) then
      local mod = file_to_module(path)
      local ok, plugin_spec = pcall(require, mod)

      if not ok then
        vim.notify("Failed to load plugin file: " .. path .. ": " .. plugin_spec, vim.log.levels.ERROR)
      else
        if plugin_spec == nil then
          -- Plugin returns nil (e.g., conditional plugin that's disabled)
        elseif type(plugin_spec) == "table" and plugin_spec.src then
          register_one(plugin_spec, path)
        elseif vim.islist(plugin_spec) then
          for _, item in ipairs(plugin_spec) do
            register_one(item, path)
          end
        else
          vim.notify("Invalid plugin spec module (expected spec or list): " .. path, vim.log.levels.ERROR)
        end
      end
    end
  end

  return pack_specs
end

function M.setup()
  local paths = list_plugins()
  local pack_specs = load_specs(paths)

  if #pack_specs > 0 then
    local ok_pack, err_pack = pcall(vim.pack.add, pack_specs, { load = false })
    if not ok_pack then
      vim.notify("vim.pack.add failed: " .. err_pack, vim.log.levels.ERROR)
      return
    end
  end

  local names = {}
  for name, _ in pairs(registry) do
    table.insert(names, name)
  end
  table.sort(names)

  for _, name in ipairs(names) do
    load_plugin(name)
  end

  for _, name in ipairs(names) do
    configure_plugin(name)
  end
end

M.setup()

