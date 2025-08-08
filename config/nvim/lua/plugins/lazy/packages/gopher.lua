-- Go language enhancements https://github.com/olexsmir/gopher.nvim

return {
  "olexsmir/gopher.nvim",
  ft = "go",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
  },
  build = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.cmd("GoInstallDeps")
      end,
    })
  end,
  config = function()
    require("gopher").setup({
      log_level = vim.log.levels.INFO,
      timeout = 2000,
      commands = {
        go = "go",
        gomodifytags = "gomodifytags",
        gotests = "gotests",
        impl = "impl",
        iferr = "iferr",
      },
      gotests = {
        template = "default",
        template_dir = nil,
        named = false,
      },
      gotag = {
        transform = "snakecase",
        default_tag = "json",
      },
      iferr = {
        message = nil,
      },
    })
    require("dap-go").setup()
  end,
}

