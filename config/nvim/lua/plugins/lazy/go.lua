-- Go language support https://github.com/ray-x/go.nvim
-- Only loads if Go is installed

if vim.fn.executable("go") == 0 then
  return {}
end

return {
  "ray-x/go.nvim",
  dependencies = { "ray-x/guihua.lua" }, -- required for floaterm and UI features
  event = { "CmdlineEnter" }, -- or use "BufReadPre" for earlier loading
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()', -- installs all necessary binaries
  config = function()
    require("go").setup({
      goimport = "gopls", -- if you prefer goimports, change this
      gofmt = "golines",    -- "gofmt", or use "golines" for line wrapping
      max_line_len = 120, -- gofmt must be 'golines' for this to work
      tag_transform = false,
      test_dir = "",
      comment_placeholder = "",
      lsp_cfg = false,     -- disable go.nvim's LSP config (we configure it ourselves)
      lsp_on_attach = false, -- we handle on_attach in lsp/core.lua
      lsp_keymaps = false, -- we define our own keymaps
      lsp_codelens = true,
      dap_debug = true,
      dap_debug_keymap = true,
      dap_debug_gui = true,
      dap_debug_vt = true,
      trouble = true,
      luasnip = true,
    })
  end,
}
