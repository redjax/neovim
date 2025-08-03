-- Setup lazy.nvim path first
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Add nvim-shared to runtimepath (prepend to load it early)
local home = vim.fn.expand("~")
local sep = package.config:sub(1,1)

-- Plugin specs
local specs = {
  { import = "plugins.lazy.packages" },
  { import = "themes" },
  -- import nvim-shared plugin specs if it exports them, or
  -- require modules manually after setup if it is config code
}

-- Setup lazy.nvim with specs
require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})

-- Manually require your lsp bundle after rtp is set
local ok, bundle = pcall(require, "nvim-shared.lsp.bundle")
if not ok then
  vim.notify("Failed to load nvim-shared.lsp.bundle: " .. tostring(bundle), vim.log.levels.ERROR)
else
  if type(bundle.setup) == "function" then
    bundle.setup()
  end
end
