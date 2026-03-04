-- Additional autocmds for LSP and filetype-specific behavior

-- Organize imports on save for Go files
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		-- Get the first LSP client to determine position encoding
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			return
		end
		
		local client = clients[1]
		local position_encoding = client.offset_encoding or "utf-16"
		
		local params = vim.lsp.util.make_range_params(nil, position_encoding)
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, position_encoding)
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end
	end,
})
