-- Guess indent https://github.com/NMAC427/guess-indent

return {
  src = "https://github.com/NMAC427/guess-indent.nvim",
  name = "guess-indent.nvim",
  setup = function()
    require("guess-indent").setup({
      auto_cmd = true,
      override_editorconfig = false,
      filetype_exclude = { "netrw", "tutor" },
      buftype_exclude = { "help", "nofile", "terminal" },
    })
  end,
}
