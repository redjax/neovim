-- LSP plugin bundle for nvim12.
-- Actual server setup and ancillary plugin wiring lives under lua/lsp/.

local ok_auto, lsp_auto_servers = pcall(require, "lsp.auto_servers")
local ok_core, lsp_core = pcall(require, "lsp.core")

if ok_auto and ok_core then
	-- Keep native LSP bootstrap independent from ancillary plugins.
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			lsp_core.setup(lsp_auto_servers.get())
		end,
	})
end

return require("lsp.bundle")
