local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Default servers for all environments
M.defaults = {
  base = {
    "lua_ls",
    "marksman",
    "postgres_lsp",
    "powershell_es",
    "superhtml",
    "tflint",
  },
  dotnet = { "bicep" },
  npm = {
    "ansiblels",
    "azure_pipelines_ls",
    "bashls",
    "css_variables",
    "cssls",
    "cssmodules_ls",
    "docker_compose_language_service",
    "dockerls",
    "eslint",
    "gh_actions_ls",
    "html",
    "jsonls",
    "pyright",
    "sqlls",
    "svelte",
    "vue_ls",
    "yamlls",
  },
  go = {
    "golangci_lint_ls",
    "gopls",
    "sqls",
  },
  pip = {},
}

-- Optional overrides (can be set from your config before calling get())
M.overrides = {
  base = nil,
  dotnet = nil,
  npm = nil,
  go = nil,
  pip = nil,
}

-- Cache table local to the module
local cached_servers = nil

function M.get()
  if cached_servers then
    return cached_servers
  end

  local ensure_installed = {}

  -- Merge defaults and overrides
  local function merge_list(key)
    local list = {}
    if M.defaults[key] then
      vim.list_extend(list, M.defaults[key])
    end
    if M.overrides[key] then
      vim.list_extend(list, M.overrides[key])
    end
    return list
  end

  -- Always include base
  vim.list_extend(ensure_installed, merge_list("base"))

  -- Conditionally include based on available executables
  if has("dotnet") then
    vim.list_extend(ensure_installed, merge_list("dotnet"))
  end

  if has("npm") then
    vim.list_extend(ensure_installed, merge_list("npm"))
  end

  if has("go") then
    vim.list_extend(ensure_installed, merge_list("go"))
  end

  if has("pip") then
    vim.list_extend(ensure_installed, merge_list("pip"))
  end

  cached_servers = ensure_installed
  return cached_servers
end

return M
