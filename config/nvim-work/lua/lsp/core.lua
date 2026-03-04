-- shared LSP foundation: capabilities, on_attach, and applying mason-lspconfig with a chosen set of servers

local M = {}

-- local cmp_lsp = require("cmp_nvim_lsp")

-- capabilities for all LSP servers
M.capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities()
)
--   cmp_lsp.default_capabilities()
-- )

-- common on_attach
function M.on_attach(client, bufnr)
  local nmap = function(keys, func, desc)
    desc = "LSP: " .. desc
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true })
  end

  nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("<leader>gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
end

-- Setup diagnostics defaults
local function setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
  })
end

-- Entry: given a list of server names, bootstrap mason-lspconfig and configure servers
function M.setup(ensure_installed)
  -- fidget for progress
  require("fidget").setup({})

  -- mason + mason-lspconfig (no automatic global install beyond provided list)
  require("mason").setup({
    registries = {
      'github:mason-org/mason-registry',
      'github:crashdummyy/mason-registry',
    },
  })

  require("mason-lspconfig").setup({
    ensure_installed = ensure_installed,
    handlers = {
      -- default handler using modern vim.lsp.config API
      function(server_name)
        vim.lsp.config[server_name] = {
          capabilities = M.capabilities,
          on_attach = M.on_attach,
          root_dir = vim.fs.root,
          single_file_support = true,
        }
      end,
      ["sqls"] = function()
        vim.lsp.config.sqls = {
          on_attach = function(client, bufnr)
            require('sqls').on_attach(client, bufnr)
            M.on_attach(client, bufnr)
          end,
          capabilities = M.capabilities,
          root_dir = vim.fs.root,
          single_file_support = true,
        }
      end,
      ["lua_ls"] = function()
        vim.lsp.config.lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
          capabilities = M.capabilities,
          on_attach = M.on_attach,
          root_dir = vim.fs.root,
          single_file_support = true,
        }
      end,
      ["powershell_es"] = function()
        local powershell_servers = require("lsp.servers.powershell")
        if powershell_servers and powershell_servers.settings then
          vim.lsp.config.powershell_es = {
            settings = powershell_servers.settings.powershell,
            capabilities = M.capabilities,
            on_attach = M.on_attach,
            filetypes = powershell_servers.filetypes,
            root_dir = vim.fs.root,
            single_file_support = true,
          }
        end
      end,
      ["pyright"] = function()
        vim.lsp.config.pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
          capabilities = M.capabilities,
          on_attach = M.on_attach,
          root_dir = vim.fs.root,
          single_file_support = true,
        }
      end,
      ["gopls"] = function()
        vim.lsp.config.gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              -- Environment settings
              env = {
                GOPATH = vim.env.GOPATH or vim.fn.expand("~/go"),
                GOROOT = vim.env.GOROOT or vim.fn.expand("~/.go"),
              },
              allowModfileModifications = true,
              directoryFilters = {
                "-**/node_modules",
                "-**/.git",
                "-**/vendor",
              },
            },
          },
          capabilities = M.capabilities,
          on_attach = M.on_attach,
          root_dir = vim.fs.root,
          single_file_support = true,
        }
      end,
      ["yamlls"] = function()
        vim.lsp.config.yamlls = {
          settings = {
            yaml = {
              schemas = require('schemastore').yaml.schemas(),
              validate = true,
            },
          },
          capabilities = M.capabilities,
          on_attach = M.on_attach,
          root_dir = vim.fs.root,
          single_file_support = true,
        }
      end,
      ["dockerls"] = function()
        local docker_servers = require("lsp.servers.docker")
        if docker_servers and docker_servers.settings and docker_servers.settings.dockerls then
          vim.lsp.config.dockerls = {
            settings = docker_servers.settings.dockerls.settings,
            filetypes = { "dockerfile", "Dockerfile" },
            capabilities = M.capabilities,
            on_attach = M.on_attach,
            root_dir = vim.fs.root,
            single_file_support = true,
          }
        else
          vim.lsp.config.dockerls = {
            filetypes = { "dockerfile", "Dockerfile" },
            capabilities = M.capabilities,
            on_attach = M.on_attach,
            root_dir = vim.fs.root,
            single_file_support = true,
          }
        end
      end,
      ["docker_compose_language_service"] = function()
        local docker_servers = require("lsp.servers.docker")
        if docker_servers and docker_servers.settings and docker_servers.settings.docker_compose_language_service then
          vim.lsp.config.docker_compose_language_service = {
            settings = docker_servers.settings.docker_compose_language_service.settings,
            capabilities = M.capabilities,
            on_attach = M.on_attach,
            filetypes = { "yaml.docker-compose" },
            root_dir = vim.fs.root,
            single_file_support = true,
          }
        else
          vim.lsp.config.docker_compose_language_service = {
            capabilities = M.capabilities,
            on_attach = M.on_attach,
            filetypes = { "yaml.docker-compose" },
            root_dir = vim.fs.root,
            single_file_support = true,
          }
        end
      end,
    },
  })

  setup_diagnostics()
end

return M
