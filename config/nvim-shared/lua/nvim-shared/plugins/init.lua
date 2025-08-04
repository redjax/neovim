local M = {}

-- Utility to dedupe and optionally merge specs: later specs override earlier.
local function normalize_key(spec)
  if spec.import then
    return "import:" .. spec.import
  elseif type(spec[1]) == "string" then
    return "pkg:" .. spec[1]
  elseif spec[1] and type(spec[1]) == "table" then
    return vim.inspect(spec[1])
  else
    return vim.inspect(spec)
  end
end

-- Merge two spec entries with the same identity, preferring 'override' values.
-- This is naive: merges 'opts' tables if present.
local function merge_spec(a, b)
  local out = vim.tbl_deep_extend("force", a, b)
  -- If both have opts and you want profile-local to win you could do:
  if a.opts and b.opts then
    out.opts = vim.tbl_deep_extend("force", a.opts, b.opts)
  end
  return out
end

-- Deduplicate list so later entries override earlier ones (local overrides shared).
local function dedupe_specs(specs)
  local seen = {}
  local out = {}
  for _, spec in ipairs(specs) do
    local key = normalize_key(spec)
    if seen[key] then
      -- merge with existing
      out[seen[key]] = merge_spec(out[seen[key]], spec)
    else
      table.insert(out, spec)
      seen[key] = #out
    end
  end
  return out
end

-- Load a shared bundle by name under plugins/lazy/<name>.lua
-- e.g., load("lazy", "work") will require "nvim-shared.plugins.lazy.work"
-- Returns list of specs or empty table.
function M.load(manager, bundle_name)
  local ok, module = pcall(require, ("nvim-shared.plugins.%s.%s"):format(manager, bundle_name))
  if not ok then
    vim.notify(("Failed to load shared bundle %s/%s: %s"):format(manager, bundle_name, module), vim.log.levels.WARN)
    return {}
  end
  if type(module) ~= "table" then
    return {}
  end
  return module
end

-- Merge shared specs + local profile specs.
-- local_specs should be a table of specs (e.g., from require("plugins") in profile)
-- shared_specs is array of shared ones (possibly from multiple bundles)
function M.merge(shared_specs, local_specs)
  local combined = {}
  vim.list_extend(combined, shared_specs or {})
  vim.list_extend(combined, local_specs or {}) -- local after shared so it overrides
  return dedupe_specs(combined)
end

return M
