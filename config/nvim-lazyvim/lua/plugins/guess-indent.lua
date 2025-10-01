-- Guess indent https://github.com/NMAC427/guess-indent.nvim
-- Automatically detects and applies the indentation style used in the current file

return {
  "NMAC427/guess-indent.nvim",
  event = "BufReadPost", -- lazy load on file open
  config = function()
    require("guess-indent").setup({
      auto_cmd = true, -- automatically run on BufReadPost
      override_editorconfig = false, -- don't override .editorconfig settings
      filetype_exclude = { 
        "netrw", 
        "tutor",
        "lazy",
        "mason",
        "help",
        "checkhealth",
      },
      buftype_exclude = { 
        "help", 
        "nofile", 
        "terminal", 
        "prompt",
      },
    })
  end,
}