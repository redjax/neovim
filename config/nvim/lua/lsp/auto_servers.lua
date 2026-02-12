local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Map of LSP servers to required external tools
local server_tool_requirements = {
  bicep = "dotnet",

  -- npm-based servers
  ansiblels = "ansible",
  azure_pipelines_ls = "ansible",
  bashls = function()
    -- Bash LSP is useful if we have bash or any shell
    return has("bash") or has("sh") or has("zsh")
  end,
  css_variables = "npm",
  cssls = "npm",
  cssmodules_ls = "npm",
  docker_compose_language_service = "docker",
  dockerls = "docker",
  eslint = "node",
  gh_actions_ls = "npm",
  html = "npm",
  jsonls = "node",
  pyright = "node",
  sqlls = "go",  -- sqlls requires Go toolchain
  svelte = "npm",
  vue_ls = "npm",
  yamlls = "npm",

  -- go servers
  golangci_lint_ls = "golangci-lint",
  gopls = "go",
  sqls = "go",

  -- cargo servers (were missing)
  gitlab_ci_ls = "cargo",
  markdown_oxide = "cargo",

  -- base / general
  lua_ls = "lua",
  marksman = "cargo",
  postgres_lsp = "psql",
  powershell_es = function() 
    -- PowerShell is available if we have pwsh or powershell
    return has("pwsh") or has("powershell")
  end,
  superhtml = nil,
  tflint = "tflint",

  -- pip servers (currently empty, add here when needed)
  -- e.g. ruff = "pip", etc.
}

M.defaults = {
  base = {
    "lua_ls",
    "marksman",
    "postgres_lsp",
    "powershell_es",
    -- "superhtml",  -- Requires xz-utils system dependency, not cross-platform
    "tflint",
  },
  dotnet = {
    "bicep",
  },
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
  pip = {
    -- Add pip servers here if any
  },
  cargo = {  -- new category added
    "gitlab_ci_ls",
    "markdown_oxide",
  },
}

M.overrides = {
  base = nil,
  dotnet = nil,
  npm = nil,
  go = nil,
  pip = nil,
  cargo = nil,  -- override support for new cargo category
}

local cached_servers = nil

local function server_tool_available(server)
  local required_tool = server_tool_requirements[server]
  
  -- No requirement means always available
  if not required_tool then
    return true
  end
  
  -- If it's a function, call it to check availability
  if type(required_tool) == "function" then
    return required_tool()
  end
  
  -- Otherwise check if the tool executable exists
  return has(required_tool)
end

function M.get()
  if cached_servers then
    return cached_servers
  end

  local ensure_installed = {}

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
    end
  end

  if has("dotnet") then
    for _, server in ipairs(merge_list("dotnet")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      end
    end
  end

  if has("npm") then
    for _, server in ipairs(merge_list("npm")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      end
    end
  end

  if has("go") then
    for _, server in ipairs(merge_list("go")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      end
    end
  end

  if has("pip") then
    for _, server in ipairs(merge_list("pip")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      end
    end
  end

  if has("cargo") then  -- new condition for cargo servers
    for _, server in ipairs(merge_list("cargo")) do
      if server_tool_available(server) then
        table.insert(ensure_installed, server)
      end
    end
  end

  cached_servers = ensure_installed
  return cached_servers
end

return M
