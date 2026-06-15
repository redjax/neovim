local M = {}
local registry = {}
local loaded = {}
local configured = {}
local ensuring = {}
local lazy_handlers_registered = {}

local function is_disabled(path)
  -- Normalize path separators to forward slashes for consistent matching
  local normalized = path:gsub("\\", "/")
  return normalized:find("plugins/disabled/") ~= nil or normalized:find("themes/disabled/") ~= nil
end

local function is_plugin_loader(path)
  -- Normalize path separators to forward slashes for consistent matching
  local normalized = path:gsub("\\", "/")
  return normalized:match("/lua/plugins/init%.lua$") ~= nil
end

local function is_ignored(path)
  local filename = vim.fs.basename(path)
  return filename:sub(1, 1) == "_"
end

local function file_to_module(path)
  -- Normalize path separators to forward slashes
  local normalized = path:gsub("\\", "/")
  
  -- Try to extract everything after "lua/" first
  local mod = normalized:match("lua/(.+)")
  
  -- If that doesn't work, try to extract just the filename and relative structure
  if not mod then
    -- Try matching from the end for patterns like ".../lua/plugins/..." -> "plugins/..."
    mod = normalized:match("^.*/lua/(.+)$")
  end
  
  if not mod then
    error("Unable to extract module path from: " .. path)
  end
  
  return mod
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

local function infer_name(src)
  local name = src:match("([^/]+)$") or src
  return name:gsub("%.git$", "")
end

local function dependency_name(dep)
  if type(dep) == "string" then
    if dep:match("^https?://") then
      return infer_name(dep)
    end
    return dep
  end

  if type(dep) == "table" then
    if type(dep.name) == "string" and dep.name ~= "" then
      return dep.name
    end
    if type(dep.src) == "string" and dep.src ~= "" then
      return infer_name(dep.src)
    end
  end

  return nil
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
    dependencies = spec.dependencies,
    lazy = spec.lazy,
    event = spec.event,
    cmd = spec.cmd,
    ft = spec.ft,
    keys = spec.keys,
  }

  return normalized, spec.setup or spec.config
end

local function listify(value)
  if value == nil then
    return {}
  end
  if vim.islist(value) then
    return value
  end
  return { value }
end

local function has_lazy_trigger(spec)
  return spec.event ~= nil or spec.cmd ~= nil or spec.ft ~= nil or spec.keys ~= nil
end

local function should_lazy_load(entry)
  local spec = entry.spec
  if spec.lazy == false then
    return false
  end
  if spec.lazy == true then
    return true
  end
  return has_lazy_trigger(spec)
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

local function ensure_plugin(name)
  if ensuring[name] then
    return true
  end

  local entry = registry[name]
  if not entry then
    vim.notify("Unknown plugin in registry: " .. name, vim.log.levels.WARN)
    return false
  end

  ensuring[name] = true

  for _, dep in ipairs(listify(entry.spec.dependencies)) do
    local dep_name = dependency_name(dep)
    if not dep_name then
      vim.notify("Invalid dependency in plugin spec for " .. name, vim.log.levels.WARN)
      ensuring[name] = nil
      return false
    end
    if not ensure_plugin(dep_name) then
      ensuring[name] = nil
      return false
    end
  end

  if not load_plugin(name) then
    ensuring[name] = nil
    return false
  end
  if not configure_plugin(name) then
    ensuring[name] = nil
    return false
  end

  ensuring[name] = nil
  return true
end

local function add_event_trigger(name, events)
  for _, event in ipairs(listify(events)) do
    vim.api.nvim_create_autocmd(event, {
      once = true,
      callback = function()
        ensure_plugin(name)
      end,
    })
  end
end

local function add_ft_trigger(name, fts)
  local patterns = listify(fts)
  if #patterns == 0 then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = patterns,
    once = true,
    callback = function()
      ensure_plugin(name)
    end,
  })
end

local function build_command_invocation(cmd_name, opts)
  local invocation = cmd_name
  if opts.bang then
    invocation = invocation .. "!"
  end
  if opts.args ~= nil and opts.args ~= "" then
    invocation = invocation .. " " .. opts.args
  end
  return invocation
end

local function add_cmd_trigger(name, commands)
  for _, cmd_name in ipairs(listify(commands)) do
    vim.api.nvim_create_user_command(cmd_name, function(opts)
      local ok = ensure_plugin(name)
      if not ok then
        return
      end

      pcall(vim.api.nvim_del_user_command, cmd_name)
      vim.cmd(build_command_invocation(cmd_name, opts))
    end, {
      nargs = "*",
      bang = true,
      desc = "Lazy-load " .. name .. " on command " .. cmd_name,
    })
  end
end

local function add_keys_trigger(name, keys)
  for _, key in ipairs(listify(keys)) do
    local lhs
    local mode = "n"
    local desc = nil

    if type(key) == "string" then
      lhs = key
    elseif type(key) == "table" then
      lhs = key[1] or key.lhs
      mode = key.mode or mode
      desc = key.desc
    end

    if type(lhs) == "string" and lhs ~= "" then
      local modes = listify(mode)
      vim.keymap.set(modes, lhs, function()
        local ok = ensure_plugin(name)
        if not ok then
          return
        end

        for _, one_mode in ipairs(modes) do
          pcall(vim.keymap.del, one_mode, lhs)
        end
        local termcodes = vim.api.nvim_replace_termcodes(lhs, true, false, true)
        vim.api.nvim_feedkeys(termcodes, "m", false)
      end, { silent = true, desc = desc or ("Lazy-load " .. name) })
    end
  end
end

local function register_lazy_handlers(name, entry)
  if lazy_handlers_registered[name] then
    return
  end
  lazy_handlers_registered[name] = true

  local spec = entry.spec
  add_event_trigger(name, spec.event)
  add_ft_trigger(name, spec.ft)
  add_cmd_trigger(name, spec.cmd)
  add_keys_trigger(name, spec.keys)

  if spec.lazy == true and not has_lazy_trigger(spec) then
    add_event_trigger(name, "UIEnter")
  end
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

  local eager_names = {}
  for name, _ in pairs(registry) do
    local entry = registry[name]
    if should_lazy_load(entry) then
      register_lazy_handlers(name, entry)
    else
      table.insert(eager_names, name)
    end
  end
  table.sort(eager_names)

  for _, name in ipairs(eager_names) do
    ensure_plugin(name)
  end
end

function M.load(name)
  return load_plugin(name)
end

function M.configure(name)
  return configure_plugin(name)
end

function M.ensure(name)
  return ensure_plugin(name)
end

M.setup()

