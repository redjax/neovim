local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

local server_tool_requirements = {
  bicep = function()
    return has("az") or has("dotnet") or has("bicep-lsp")
  end,
  bashls = "bash-language-server",
  dockerls = "docker-langserver",
  docker_compose_language_service = "docker-compose-langserver",
  gopls = "gopls",
  lua_ls = function()
    return has("lua-language-server") or has("lua_ls")
  end,
  pyright = function()
    return has("pyright-langserver") or has("basedpyright-langserver")
  end,
  ruff = "ruff",
  powershell_es = function()
    return has("pwsh") or has("powershell")
  end,
  terraformls = "terraform-ls",
  tflint = "tflint",
  yamlls = "yaml-language-server",
  jsonls = function()
    return has("vscode-json-language-server") or has("vscode-json-languageserver")
  end,
  sqlls = "sqlls",
  sqls = "sqls",
  golangci_lint_ls = "golangci-lint-langserver",
}

M.defaults = {
  base = {
    "lua_ls",
    "yamlls",
    "jsonls",
  },
  conditional = {
    "bashls",
    "powershell_es",
    "pyright",
    "ruff",
    "gopls",
    "golangci_lint_ls",
    "terraformls",
    "tflint",
    "bicep",
    "sqlls",
    "sqls",
    "dockerls",
    "docker_compose_language_service",
  },
}

function M.get()
  local available_servers = {}

  for _, server in ipairs(M.defaults.base) do
    local requirement = server_tool_requirements[server]
    if type(requirement) == "function" and requirement() then
      table.insert(available_servers, server)
    elseif type(requirement) == "string" and has(requirement) then
      table.insert(available_servers, server)
    end
  end

  for _, server in ipairs(M.defaults.conditional) do
    local requirement = server_tool_requirements[server]
    local include = false

    if type(requirement) == "function" then
      include = requirement()
    elseif type(requirement) == "string" then
      include = has(requirement)
    end

    if include then
      table.insert(available_servers, server)
    end
  end

  return available_servers
end

function M.get_mason_tools()
  local tools = {
    "stylua",
    "shellcheck",
    "shfmt",
    "prettier",
    "yaml-language-server",
    "json-lsp",
    "taplo",
    "actionlint",
    "yamllint",
  }

  if has("python") or has("python3") then
    vim.list_extend(tools, {
      "pyright",
      "ruff",
      "black",
      "isort",
      "mypy",
      "flake8",
    })
  end

  if has("bash") or has("sh") or has("zsh") then
    table.insert(tools, "bash-language-server")
  end

  if has("pwsh") or has("powershell") then
    table.insert(tools, "powershell-editor-services")
  end

  if has("node") or has("npm") then
    vim.list_extend(tools, {
      "typescript-language-server",
      "eslint_d",
    })
  end

  if has("go") then
    vim.list_extend(tools, {
      "gopls",
      "gofumpt",
      "goimports",
      "golines",
      "golangci-lint",
    })
  end

  if has("cargo") then
    table.insert(tools, "rust-analyzer")
  end

  vim.list_extend(tools, {
    "dockerfile-language-server",
    "docker-compose-language-service",
    "hadolint",
  })

  if has("terraform") then
    vim.list_extend(tools, {
      "terraform-ls",
      "tflint",
    })
  end

  if has("az") or has("dotnet") then
    table.insert(tools, "bicep-lsp")
  end

  vim.list_extend(tools, {
    "sqlls",
    "sqlfmt",
  })

  return tools
end

function M.load_server_configs()
  local configs = {}
  local server_files = {
    "bash",
    "bicep",
    "docker",
    "go",
    "json",
    "powershell",
    "python",
    "sql",
    "terraform",
    "yaml",
    "csv",
    "markdown",
  }

  for _, file in ipairs(server_files) do
    local ok, config = pcall(require, "lsp.servers." .. file)
    if ok and config then
      if config.condition then
        if config.condition() then
          configs[config.name] = config
        end
      else
        configs[config.name] = config
      end
    end
  end

  return configs
end

return M
