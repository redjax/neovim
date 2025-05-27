local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
      -- { import = "plugins.lazy" },
      { import = "plugins.lazy.lsp" },
      { import = "plugins.lazy.packages"},
      { import = "themes"}
    },
    change_detection = { notify = false },
    
    -- Automatically check for updates
    checker = { enabled = true },
})
