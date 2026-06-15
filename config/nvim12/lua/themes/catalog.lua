local M = {}
local loaded = false

local function infer_name(src)
  local name = src:match("([^/]+)$") or src
  return name:gsub("%.git$", "")
end

function M.load()
  if loaded then
    return true
  end

  local ok_catalog, catalog = pcall(require, "themes.all")
  if not ok_catalog then
    vim.notify("Failed to load theme catalog: " .. catalog, vim.log.levels.ERROR)
    return false
  end

  local pack_specs = {}
  local setup_entries = {}

  for _, raw_spec in ipairs(catalog) do
    if type(raw_spec) == "table" and type(raw_spec.src) == "string" and raw_spec.src ~= "" then
      local spec = {
        src = raw_spec.src,
        name = raw_spec.name or infer_name(raw_spec.src),
        version = raw_spec.version,
      }

      table.insert(pack_specs, spec)
      table.insert(setup_entries, {
        name = spec.name,
        spec = spec,
        setup = raw_spec.setup or raw_spec.config,
      })
    end
  end

  if #pack_specs > 0 then
    local ok_add, err_add = pcall(vim.pack.add, pack_specs, { load = false })
    if not ok_add then
      vim.notify("Failed to register theme catalog: " .. err_add, vim.log.levels.ERROR)
      return false
    end
  end

  for _, entry in ipairs(setup_entries) do
    local ok_packadd, err_packadd = pcall(vim.cmd.packadd, entry.name)
    if not ok_packadd then
      vim.notify("Failed to load theme plugin " .. entry.name .. ": " .. err_packadd, vim.log.levels.WARN)
    elseif type(entry.setup) == "function" then
      local ok_setup, err_setup = pcall(entry.setup, entry.spec)
      if not ok_setup then
        vim.notify("Theme setup failed for " .. entry.name .. ": " .. err_setup, vim.log.levels.WARN)
      end
    end
  end

  loaded = true
  return true
end

return M