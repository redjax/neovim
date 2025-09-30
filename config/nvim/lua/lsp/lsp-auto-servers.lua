-- LSP Auto Servers with comprehensive language support
-- Automatically detects available tools and configures appropriate LSP servers

local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Map of LSP servers to required external tools
local server_tool_requirements = {
  -- Core language servers
  bicep = "az",  -- Requires Azure CLI
  bashls = function()
    return has("bash") or has("sh") or has("zsh")
  end,
  dockerls = "docker",
  gopls = "go",
  lua_ls = "lua",
  marksman = function()
    return has("marksman") or has("cargo")
  end,
  pyright = function()
    return has("python") or has("python3")
  end,
  powershell_es = function() 
    return has("pwsh") or has("powershell")
  end,
  rust_analyzer = "cargo",
  terraformls = "terraform",
  
  -- YAML and configuration
  yamlls = "npm",
  jsonls = "node",
  
  -- SQL servers
  sqlls = "go",
  
  -- Web/CSS/HTML (npm-based)
  ansiblels = "ansible",
  azure_pipelines_ls = "npm",
  css_variables = "npm",
  cssls = "npm",
  cssmodules_ls = "npm",
  docker_compose_language_service = "docker",
  eslint = "node",
  gh_actions_ls = "npm",
  html = "npm",
  svelte = "npm",
  vue_ls = "npm",
  
  -- Go tools
  golangci_lint_ls = "golangci-lint",
  sqls = "go",
  
  -- Cargo-based tools
  gitlab_ci_ls = "cargo",
  markdown_oxide = "cargo",
  
  -- Additional tools
  postgres_lsp = "psql",
  superhtml = nil,
  tflint = "tflint",
}

M.defaults = {
  base = {
    "lua_ls",
    "yamlls",
    "jsonls",
  },
  conditional = {
    -- These are checked dynamically based on tool availability
    "bashls",
    "powershell_es",
    "pyright",
    "gopls",
    "rust_analyzer",
    "dockerls",
    "terraformls",
    "bicep",
    "sqlls",
    "marksman", -- Moved to conditional since it requires cargo
  },
  npm = {
    "eslint",
    "html",
    "cssls",
    "azure_pipelines_ls",
    "gh_actions_ls",
  },
  go = {
    "golangci_lint_ls",
    "sqls",
  },
  cargo = {
    "gitlab_ci_ls",
    "markdown_oxide",
  },
  specialized = {
    "postgres_lsp",
    "tflint",
    "superhtml",
  }
}

-- Enhanced get function that checks tool availability
function M.get()
  local available_servers = {}
  
  -- Always include base servers
  for _, server in ipairs(M.defaults.base) do
    table.insert(available_servers, server)
  end
  
  -- Check conditional servers
  for _, server in ipairs(M.defaults.conditional) do
    local requirement = server_tool_requirements[server]
    local should_include = false
    
    if type(requirement) == "function" then
      should_include = requirement()
    elseif type(requirement) == "string" then
      should_include = has(requirement)
    elseif requirement == nil then
      should_include = true
    end
    
    if should_include then
      table.insert(available_servers, server)
    end
  end
  
  -- Add npm servers if Node.js is available
  if has("node") or has("npm") then
    for _, server in ipairs(M.defaults.npm) do
      table.insert(available_servers, server)
    end
  end
  
  -- Add Go servers if Go is available
  if has("go") then
    for _, server in ipairs(M.defaults.go) do
      table.insert(available_servers, server)
    end
  end
  
  -- Add Cargo servers if Rust is available
  if has("cargo") then
    for _, server in ipairs(M.defaults.cargo) do
      table.insert(available_servers, server)
    end
  end
  
  -- Add specialized servers (check individually)
  for _, server in ipairs(M.defaults.specialized) do
    local requirement = server_tool_requirements[server]
    if requirement == nil or (type(requirement) == "string" and has(requirement)) then
      table.insert(available_servers, server)
    end
  end
  
  return available_servers
end

-- Function to get tools for Mason installation
function M.get_mason_tools()
  local tools = {
    -- Core tools always installed
    "stylua",
    "shellcheck", 
    "shfmt",
    "prettier",
    "yaml-language-server",
    "json-lsp",
  }
  
  -- Language-specific tools based on availability
  if has("cargo") then
    table.insert(tools, "marksman")
  end
  
  if has("python") or has("python3") then
    vim.list_extend(tools, {
      "pyright",
      "ruff-lsp",
      "flake8", 
      "black",
      "isort",
      "mypy"
    })
  end
  
  if has("bash") or has("sh") or has("zsh") then
    table.insert(tools, "bash-language-server")
  end
  
  if has("pwsh") or has("powershell") then
    table.insert(tools, "powershell-editor-services")
  end
  
  if has("go") then
    vim.list_extend(tools, {
      "gopls",
      "golangci-lint-langserver",
      "gofumpt",
      "goimports",
      "golines"
    })
  end
  
  if has("cargo") then
    table.insert(tools, "rust-analyzer")
  end
  
  if has("docker") then
    vim.list_extend(tools, {
      "dockerfile-language-server",
      "docker-compose-language-service",
      "hadolint"
    })
  end
  
  if has("terraform") then
    vim.list_extend(tools, {
      "terraform-ls",
      "tflint"
    })
  end
  
  if has("az") then
    table.insert(tools, "bicep-lsp")
  end
  
  if has("node") or has("npm") then
    vim.list_extend(tools, {
      "typescript-language-server",
      "eslint_d"
    })
  end
  
  -- Additional linters and formatters
  vim.list_extend(tools, {
    "yamllint",
    "actionlint",
    "sqlls",
  })
  
  return tools
end

-- Load server configurations from individual files
function M.load_server_configs()
  local configs = {}
  local server_files = {
    "yaml",
    "docker",
    "terraform",
    "json",
    "sql", 
    "go",
    "python",
    "bicep",
    "powershell",
    "csv",
    "markdown",
  }
  
  for _, file in ipairs(server_files) do
    local ok, config = pcall(require, "lsp.servers." .. file)
    if ok and config then
      -- Check if the config has a condition function
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