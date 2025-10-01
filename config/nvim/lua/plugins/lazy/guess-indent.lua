-- Guess indent https://github.com/NMAC427/guess-indent

return {
  "NMAC427/guess-indent.nvim",
  config = function()
    require("guess-indent").setup {
      auto_cmd = true,  -- automatically run on BufReadPost
      override_editorconfig = false,  -- don't override .editorconfig settings
      filetype_exclude = { "netrw", "tutor" },  -- optional: exclude certain filetypes
      buftype_exclude = { "help", "nofile", "terminal" },  -- optional: exclude certain buffer types
    }
  end,
  event = "BufReadPost",  -- lazy load on file open
}
