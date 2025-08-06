-- Bootstrap lazy.nvim
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
vim.opt.rtp:prepend(lazypath) -- consistent shorthand

-- Shared path setup (cross-platform)
local home = vim.fn.expand("~")
local sep = package.config:sub(1,1)
local nvim_shared_root
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  local localappdata = vim.env.LOCALAPPDATA or (home .. sep .. "AppData" .. sep .. "Local")
  nvim_shared_root = localappdata .. sep .. "nvim-shared"
else
  nvim_shared_root = home .. sep .. ".config" .. sep .. "nvim-shared"
end

-- Base specs
local specs = {
  { import = "plugins" },
  { import = "themes" },
}

if vim.fn.isdirectory(nvim_shared_root) == 1 then
  vim.opt.rtp:prepend(nvim_shared_root)

  -- Add lua subdirectory to package.path if needed, avoid duplication
  local shared_lua = nvim_shared_root .. sep .. "lua"
  local new_paths = {
    shared_lua .. "/?.lua",
    shared_lua .. "/?/init.lua",
  }
  for _, p in ipairs(new_paths) do
    if not package.path:find(p, 1, true) then
      package.path = p .. ";" .. package.path
    end
  end

  -- Require auto_servers with error handling
  local ok_auto, auto_servers = pcall(require, "nvim-shared.lsp.auto_servers")
  local servers = {}
  if ok_auto and auto_servers then
    auto_servers.overrides = auto_servers.overrides or {}
    auto_servers.overrides.base = {
      "lua_ls",
      "marksman",
      "powershell_es",
      "superhtml",
      "tflint",
    }
    auto_servers.overrides.npm = {
      "ansiblels",
      "bashls",
      "docker_compose_language_service",
      "dockerls",
      "gh_actions_ls",
      "html",
      "jsonls",
      "pyright",
      "sqlls",
      "yamlls",
    }
    auto_servers.overrides.dotnet = {} -- disable dotnet servers for this profile if desired

    servers = auto_servers.get() or {}
  else
    vim.notify("Could not load nvim-shared.lsp.auto_servers: " .. tostring(auto_servers), vim.log.levels.WARN)
  end

  -- Add shared LSP plugin specs
  table.insert(specs, { import = "nvim-shared.lsp.plugins.mason" })
  -- table.insert(specs, { import = "nvim-shared.lsp.plugins.cmp" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.signature" })
  table.insert(specs, { import = "nvim-shared.lsp.plugins.none_ls" })
  table.insert(specs, { import = "nvim-shared.lsp.bundle", opts = { ensure_installed = servers } })
  table.insert(specs, { import = "nvim-shared.lsp.dap" })
end

-- Setup lazy.nvim
require("lazy").setup({
  spec = specs,
  change_detection = { notify = false },
  checker = { enabled = true },
})
