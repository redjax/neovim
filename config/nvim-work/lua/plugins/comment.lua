-- Comment https://github.com/numToStr/Comment.nvim

return {
  'numToStr/Comment.nvim',
  opts = {},
  config = function()
    require('Comment').setup {
        padding = true,          -- Add space between comment and line
        sticky = true,           -- Cursor stays in position after commenting
        toggler = {
            line = 'gcc',
            block = 'gbc',
        },
        opleader = {
            line = 'gc',
            block = 'gb',
        },
        extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
        },
    }
  end
}
