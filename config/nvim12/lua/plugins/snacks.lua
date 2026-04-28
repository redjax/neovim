-- Snacks https://github.com/folke/snacks.nvim

return {
  src = "https://github.com/folke/snacks.nvim",
  name = "snacks.nvim",

  setup = function()
    local opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      bufdelete = { enabled = false },
      dashboard = { enabled = false },
      debug = { enabled = false },
      dim = { enabled = false },
      explorer = { enabled = false },
      git = { enabled = false },
      gitbrowse = { enabled = false },
      image = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      layout = { enabled = false },
      lazygit = { enabled = true },
      notifier = { enabled = false },
      notify = { enabled = false },
      picker = { enabled = true },
      profiler = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scratch = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      terminal = { enabled = false },
      toggle = { enabled = false },
      util = { enabled = false },
      win = { enabled = false },
      words = { enabled = true },
      zen = { enabled = false },
    }
    require("snacks").setup(opts)
  end,
}
