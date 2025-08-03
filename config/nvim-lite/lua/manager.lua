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

-- Set $HOME dir (cross platform)
local home = vim.fn.expand("~")
-- Detect path separator (/ or \)
local sep = package.config:sub(1,1)
-- Build path to shared nvim-shared language server config
local nvim_shared_path = home .. sep .. ".config" .. sep .. "nvim-shared"

-- Build specs object for lazy init
local specs = {
  { import = "plugins" },
  { import = "themes" },
}

-- Check if nvim-shared config path exists
if vim.loop.fs_stat(nvim_shared_path) and vim.loop.fs_stat(nvim_shared_path).type == "directory" then
  vim.opt.runtimepath:append(nvim_shared_path)
  table.insert(specs, { import = "nvim-shared.lsp.lsp_plugins.mason" })
  table.insert(specs, { import = "nvim-shared.lsp.lsp_plugins.dap" })
  table.insert(specs, { import = "nvim-shared.lsp.lsp_plugins.none_ls" })
end

require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
