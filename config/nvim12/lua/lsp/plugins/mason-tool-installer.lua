return {
  src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  name = "mason-tool-installer.nvim",

  setup = function()
    local ok, installer = pcall(require, "mason-tool-installer")
    if not ok then
      vim.notify("mason-tool-installer failed to load", vim.log.levels.ERROR)
      return
    end

    installer.setup({
      ensure_installed = require("lsp.auto_servers").get_mason_tools(),
      run_on_start = true,
      start_delay = 2000,
      auto_update = false,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsUpdateCompleted",
      callback = function()
        vim.notify("Mason tools installed", vim.log.levels.INFO)
      end,
    })
  end,
}
