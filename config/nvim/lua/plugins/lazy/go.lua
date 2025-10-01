-- Go language support https://github.com/ray-x/go.nvim

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
      lsp_cfg = true,     -- use default gopls setup
      lsp_on_attach = true,
      lsp_keymaps = true,
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
