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

local home = vim.fn.expand("~")
local sep = package.config:sub(1, 1)
local nvim_lsp_path = home .. sep .. ".config" .. sep .. "nvim-lsp"

local specs = {
  { import = "plugins" },
  { import = "themes" },
}

if vim.loop.fs_stat(nvim_lsp_path) and vim.loop.fs_stat(nvim_lsp_path).type == "directory" then
  vim.opt.runtimepath:append(nvim_lsp_path)
  table.insert(specs, { import = "nvim-lsp" })
end

require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
