-- Go language enhancements https://github.com/olexsmir/gopher.nvim
-- Only loads if Go is installed

if vim.fn.executable("go") == 0 then
  return nil
end

return {
  src = "https://github.com/olexsmir/gopher.nvim",
  name = "gopher.nvim",

  setup = function()
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

    -- Run `GoInstallDeps` on first Go file.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        vim.cmd("GoInstallDeps")
      end,
    })
  end,
}
