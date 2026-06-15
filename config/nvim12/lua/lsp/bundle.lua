local specs = {}
vim.list_extend(specs, require("lsp.core_bundle"))
vim.list_extend(specs, require("lsp.dap_bundle"))
return specs
