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
  setup_diagnostics()
  setup_lsp_keymaps()

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

  for _, config in pairs(server_configs) do
    if config.servers then
      for _, server_name in ipairs(config.servers) do
        if vim.tbl_contains(ensure_installed, server_name) then
          local per_server_settings = config.settings and (config.settings[server_name] or config.settings) or nil
          local merged = vim.tbl_deep_extend(
            "force",
            vim.lsp.config[server_name] or {},
            {
              capabilities = M.capabilities,
              filetypes = config.filetypes,
              settings = per_server_settings,
            }
          )

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
  end

  for _, server_name in ipairs(ensure_installed) do
    vim.lsp.enable(server_name)
  end
end

return M
