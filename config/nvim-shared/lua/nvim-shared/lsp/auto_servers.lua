local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Map of LSP servers to required external tools
-- If tool is nil or missing, assume no special tool required
local server_tool_requirements = {
  -- dotnet servers (bicep requires dotnet)
  bicep = "dotnet",

  -- npm-based servers
  ansiblels = "ansible",
  azure_pipelines_ls = "ansible",          -- example, adjust as needed
  bashls = "bash",
  css_variables = "npm",                   -- assumes npm present; adjust or nil to skip
  cssls = "npm",
  cssmodules_ls = "npm",
  docker_compose_language_service = "docker",
  dockerls = "docker",
  eslint = "node",
  gh_actions_ls = "npm",
  html = "npm",
  jsonls = "node",
  pyright = "node",
  sqlls = "sql",                           -- may work without extra deps, adjust
  svelte = "npm",
  vue_ls = "npm",
  yamlls = "npm",

  -- go servers
  golangci_lint_ls = "golangci-lint",
  gopls = "go",
  sqls = "sql",

  -- base / general
  lua_ls = "lua",
  marksman = "cargo",                      -- example; if it needs cargo; adjust accordingly
  postgres_lsp = "psql",                   -- example; adjust as needed
  powershell_es = "pwsh",                  -- powershell executable
  superhtml = nil,                         -- assume no tooling needed
  tflint = "tflint",
}

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

local function server_tool_available(server)
  local required_tool = server_tool_requirements[server]
  -- If no tool required or tool is unknown, assume available
  if not required_tool then
    return true
  end
  return has(required_tool)
end

function M.get()
  if cached_servers then
    return cached_servers
  end

  local ensure_installed = {}

  -- Merge defaults and overrides
  local function merge_list(key)
    if M.overrides[key] ~= nil then
      return M.overrides[key]
    end
    return M.defaults[key] or {}
  end

  -- Always include base
  for _, server in ipairs(merge_list("base")) do
    if server_tool_available(server) then
      table.insert(ensure_installed, server)
    -- else
    --   vim.notify(("Skipping '%s' because required tool '%s' is missing"):format(server, server_tool_requirements[server]), vim.log.levels.WARN)
    end
  end

  -- Conditionally include based on available executables
  if has("dotnet") then
    for _, server in ipairs(merge_list("dotnet")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      -- else
      --   vim.notify(("Skipping '%s' because required tool '%s' is missing"):format(server, server_tool_requirements[server]), vim.log.levels.WARN)
      end
    end
  end

  if has("npm") then
    for _, server in ipairs(merge_list("npm")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      -- else
      --   vim.notify(("Skipping '%s' because required tool '%s' is missing"):format(server, server_tool_requirements[server]), vim.log.levels.WARN)
      end
    end
  end

  if has("go") then
    for _, server in ipairs(merge_list("go")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      -- else
      --   vim.notify(("Skipping '%s' because required tool '%s' is missing"):format(server, server_tool_requirements[server]), vim.log.levels.WARN)
      end
    end
  end

  if has("pip") then
    for _, server in ipairs(merge_list("pip")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      -- else
      --   vim.notify(("Skipping '%s' because required tool '%s' is missing"):format(server, server_tool_requirements[server]), vim.log.levels.WARN)
      end
    end
  end

  cached_servers = ensure_installed
  return cached_servers
end

return M
