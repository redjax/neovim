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

local has_nvim_lsp = vim.fn.isdirectory(nvim_lsp_path) == 1

local specs = {
  { import = "plugins" },
  { import = "themes" },
}

if has_nvim_lsp then
  vim.opt.runtimepath:append(nvim_lsp_path)
  local ok, err = pcall(require, "lsp.init")
  if not ok then
    vim.notify("Failed to load shared LSP config: " .. tostring(err), vim.log.levels.WARN)
  end
end

require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
