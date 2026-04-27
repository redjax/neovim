-- Navic https://github.com/hasansujon786/nvim-navic

vim.pack.add({
  { src = "https://github.com/hasansujon786/nvim-navic", },
})

return {
  setup = function()
    vim.schedule(function()
      local navic = require("nvim-navic")

      local opts = {
        lsp = {
          auto_attach = true,
          preference = { "yamlls" },
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
      }

      navic.setup(opts)

      -- Re‑attach navic and enable winbar when an LSP client attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          local server_name = client.name
          local buf = args.buf

          -- Only attach if this server provides documentSymbol
          if not client.server_capabilities.documentSymbolProvider then
            return
          end

          navic.attach(client, buf)

          -- Set winbar for this buffer to show navic breadcrumbs
          vim.api.nvim_set_option_value(
            "winbar",
            "%{%v:lua.require'nvim-navic'.get_location()%}",
            { scope = "local", win = 0 }
          )
        end,
      })
    end)
  end
}

