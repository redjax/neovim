return {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    lazy = false,
    opts = function(_, opts)
        -- Use the LSP auto servers to get comprehensive tool list
        local lsp_auto_servers = require("lsp.lsp-auto-servers")
        local mason_tools = lsp_auto_servers.get_mason_tools()
        
        -- Ensure we have the tools needed
        opts.ensure_installed = mason_tools
        
        return opts
    end,
}