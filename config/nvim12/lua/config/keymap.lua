-- Set leader key (optional, recommended)
vim.g.mapleader = " " -- Space as leader

-- Set local leader key to \
vim.g.maplocalleader = '\\'

-- Save file with <leader>w
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {
  desc = 'Save file'
})

-- File tree toggle with explicit first-use bootstrap to avoid setup ordering races.
vim.keymap.set('n', '<leader>e', function()
  if not vim.g.nvim_tree_setup_done then
    pcall(vim.cmd.packadd, 'nvim-tree.lua')

    local ok_spec, spec = pcall(require, 'plugins.nvim-tree')
    if ok_spec and type(spec) == 'table' and type(spec.setup) == 'function' then
      pcall(spec.setup)
    end
  end

  local ok_api, api = pcall(require, 'nvim-tree.api')
  if ok_api then
    api.tree.toggle()
  else
    vim.notify('nvim-tree not available', vim.log.levels.ERROR)
  end
end, {
  desc = 'Toggle NvimTree',
  silent = true,
})

-- Copy to system clipboard
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {
  desc = 'Copy to clipboard'
})

-- Paste from system clipboard
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {
  desc = 'Paste from clipboard'
})

-- Delete without affecting registers
vim.keymap.set({'n', 'x'}, 'x', '"_x', {
  desc = 'Delete without yank'
})
vim.keymap.set({'n', 'x'}, 'X', '"_d', {
  desc = 'Delete line without yank'
})

-- Select all
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>', {
  desc = 'Select all'
})

-- Home & end keys
vim.keymap.set('n', '<Home>', '^', {
  desc = 'Go to first non-blank character'
})
vim.keymap.set('n', '<End>', '$', {
  desc = 'Go to end of line'
})
vim.keymap.set('i', '<Home>', '<C-o>^', {
  desc = 'Insert: go to start of line'
})
vim.keymap.set('i', '<End>', '<C-o>$', {
  desc = 'Insert: go to end of line'
})

-- Use Tab and Shift+Tab to cycle between buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", {
  silent = true,
  desc = "Next buffer"
})
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", {
  silent = true,
  desc = "Previous buffer"
})
