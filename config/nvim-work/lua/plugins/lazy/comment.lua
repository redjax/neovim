-- Comment https://github.com/numToStr/Comment.nvim

return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup({
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
      mappings = {
        basic = true,
        extra = true,
      },
    })
    
    -- VSCode-like CTRL+/ keybindings
    -- Note: Some terminals send CTRL+/ as CTRL+_ (underscore)
    vim.keymap.set("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
    vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
    vim.keymap.set("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })
    vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })
    vim.keymap.set("i", "<C-/>", "<Esc>gcca", { desc = "Toggle comment", remap = true })
    vim.keymap.set("i", "<C-_>", "<Esc>gcca", { desc = "Toggle comment", remap = true })
  end,
}
