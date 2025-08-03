local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

local function base_servers()
  return {
    "lua_ls",
    "marksman",
    "postgres_lsp",
    "powershell_es",
    "superhtml",
    "tflint",
  }
end

-- Cache table local to the module
local cached_servers = nil

function M.get()
  -- If cached, return immediately
  if cached_servers then
    return cached_servers
  end

  local ensure_installed = {}
  vim.list_extend(ensure_installed, base_servers())

  if has("dotnet") then
    table.insert(ensure_installed, "bicep")
  end

  if has("npm") then
    vim.list_extend(ensure_installed, {
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
    })
  end

  if has("go") then
    vim.list_extend(ensure_installed, {
      "golangci_lint_ls",
      "gopls",
      "sqls",
    })
  end

  if has("pip") then
    -- Add Python servers if needed
  end

  -- Cache the result
  cached_servers = ensure_installed
  return cached_servers
end

return M
