return {
  src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  name = "mason-tool-installer.nvim",
  setup = function()
    local ok, installer = pcall(require, "mason-tool-installer")
    if not ok then
      return
    end

    installer.setup({
      ensure_installed = require("lsp.auto_servers").get_mason_tools(),
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsUpdateCompleted",
      callback = function()
        vim.notify("Mason tools installation complete!", vim.log.levels.INFO)
      end,
    })
  end,
}
