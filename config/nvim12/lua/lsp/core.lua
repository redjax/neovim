local M = {}

M.capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities()
)

local function setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
  })
end

local function ensure_mason_bin_on_path()
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if vim.fn.isdirectory(mason_bin) == 1 and not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end
end

local function find_executable(candidates)
  for _, candidate in ipairs(candidates) do
    local path = vim.fn.exepath(candidate)
    if path and path ~= "" then
      return path
    end
  end

  return nil
end

local function resolve_cmd(server_name)
  local exe = nil

  if server_name == "pyright" then
    exe = find_executable({ "pyright-langserver", "basedpyright-langserver" })
    return exe and { exe, "--stdio" } or nil
  elseif server_name == "ruff" then
    exe = find_executable({ "ruff" })
    return exe and { exe, "server" } or nil
  elseif server_name == "jsonls" then
    exe = find_executable({ "vscode-json-language-server", "vscode-json-languageserver" })
    return exe and { exe, "--stdio" } or nil
  elseif server_name == "yamlls" then
    exe = find_executable({ "yaml-language-server" })
    return exe and { exe, "--stdio" } or nil
  elseif server_name == "bashls" then
    exe = find_executable({ "bash-language-server" })
    return exe and { exe, "start" } or nil
  elseif server_name == "dockerls" then
    exe = find_executable({ "docker-langserver" })
    return exe and { exe, "--stdio" } or nil
  elseif server_name == "docker_compose_language_service" then
    exe = find_executable({ "docker-compose-langserver" })
    return exe and { exe, "--stdio" } or nil
  elseif server_name == "terraformls" then
    exe = find_executable({ "terraform-ls" })
    return exe and { exe, "serve" } or nil
  elseif server_name == "lua_ls" then
    exe = find_executable({ "lua-language-server", "lua_ls" })
    return exe and { exe } or nil
  elseif server_name == "gopls" then
    exe = find_executable({ "gopls" })
    return exe and { exe } or nil
  elseif server_name == "sqlls" then
    exe = find_executable({ "sqlls" })
    return exe and { exe } or nil
  elseif server_name == "sqls" then
    exe = find_executable({ "sqls" })
    return exe and { exe } or nil
  elseif server_name == "bicep" then
    exe = find_executable({ "bicep-lsp" })
    return exe and { exe } or nil
  end

  return nil
end

local function normalize_settings(server_name, raw)
  if type(raw) ~= "table" then
    return raw
  end

  if server_name == "pyright" and (raw.analysis or raw.disableOrganizeImports ~= nil) then
    return {
      pyright = {
        disableOrganizeImports = raw.disableOrganizeImports,
      },
      python = {
        analysis = raw.analysis or {},
      },
    }
  end

  if server_name == "jsonls" and raw.schemas then
    return { json = raw }
  end

  if server_name == "yamlls" and raw.schemaStore then
    return { yaml = raw }
  end

  if server_name == "gopls" and raw.analyses then
    return { gopls = raw }
  end

  if (server_name == "dockerls" or server_name == "docker_compose_language_service") and raw.settings then
    return raw.settings
  end

  if server_name == "powershell_es" and raw.codeFormatting then
    return { powershell = raw }
  end

  if server_name == "bicep" and raw.experimental then
    return { bicep = raw }
  end

  return raw
end

local function setup_lsp_keymaps()
  local group = vim.api.nvim_create_augroup("Nvim12LspAttach", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")

      local nmap = function(keys, func, desc)
        vim.keymap.set("n", keys, func, {
          buffer = bufnr,
          desc = "LSP: " .. desc,
          noremap = true,
        })
      end

      nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      nmap("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      nmap("K", vim.lsp.buf.hover, "Hover")

      if telescope_ok then
        nmap("<leader>gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
      else
        nmap("<leader>gr", vim.lsp.buf.references, "[G]oto [R]eferences")
      end
    end,
  })
end

function M.setup(ensure_installed)
  ensure_mason_bin_on_path()
  setup_diagnostics()
  setup_lsp_keymaps()

  pcall(vim.api.nvim_create_user_command, "Lsp", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      vim.notify("No active LSP clients for current buffer", vim.log.levels.WARN)
      return
    end

    local names = {}
    for _, client in ipairs(clients) do
      table.insert(names, client.name)
    end
    table.sort(names)
    vim.notify("Active LSP clients: " .. table.concat(names, ", "), vim.log.levels.INFO)
  end, { desc = "Show active LSP clients" })

  local default_config = {
    capabilities = M.capabilities,
    root_markers = { ".git" },
  }

  for _, server_name in ipairs(ensure_installed) do
    vim.lsp.config[server_name] = vim.tbl_deep_extend(
      "force",
      vim.lsp.config[server_name] or {},
      default_config
    )
  end

  local server_configs = require("lsp.auto_servers").load_server_configs()

  local to_enable = {}

  for _, server_name in ipairs(ensure_installed or {}) do
    to_enable[server_name] = true
  end

  for _, config in pairs(server_configs) do
    if config.servers then
      for _, server_name in ipairs(config.servers) do
        to_enable[server_name] = true

        local per_server_settings = config.settings and (config.settings[server_name] or config.settings) or nil
        local per_server_init_options = nil

        if type(per_server_settings) == "table" and per_server_settings.init_options then
          per_server_init_options = per_server_settings.init_options
          per_server_settings = vim.deepcopy(per_server_settings)
          per_server_settings.init_options = nil
          if vim.tbl_isempty(per_server_settings) then
            per_server_settings = nil
          end
        end

        per_server_settings = normalize_settings(server_name, per_server_settings)
        local merged = vim.tbl_deep_extend(
          "force",
          vim.lsp.config[server_name] or {},
          {
            capabilities = M.capabilities,
            filetypes = config.filetypes,
            settings = per_server_settings,
            init_options = per_server_init_options,
          }
        )

        merged.cmd = merged.cmd or resolve_cmd(server_name)

        if server_name == "lua_ls" then
          merged.root_markers = { ".luarc.json", ".luarc.jsonc", ".git" }
        elseif server_name == "gopls" then
          merged.root_markers = { "go.work", "go.mod", ".git" }
          merged.capabilities = vim.tbl_deep_extend(
            "force",
            M.capabilities,
            { offsetEncoding = { "utf-8", "utf-16" } }
          )
        elseif server_name == "terraformls" or server_name == "tflint" then
          merged.root_markers = { ".terraform", ".git" }
        end

        vim.lsp.config[server_name] = merged
      end
    end
  end

  for server_name, _ in pairs(to_enable) do
    vim.lsp.enable(server_name)
  end
end

return M
