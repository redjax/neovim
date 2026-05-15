-- Go language support [https://github.com/ray-x/go.nvim](https://github.com/ray-x/go.nvim)
-- Only loads if Go is installed

return {
  src = "https://github.com/ray-x/go.nvim",
  name = "go.nvim",

  setup = function()
    require("go").setup({
      goimport = "gopls",
      gofmt = "golines",
      max_line_len = 120,
      tag_transform = false,
      test_dir = "",
      comment_placeholder = "",
      lsp_cfg = false,
      lsp_on_attach = false,
      lsp_keymaps = false,
      lsp_codelens = true,
      dap_debug = true,
      dap_debug_keymap = true,
      dap_debug_gui = true,
      dap_debug_vt = true,
      trouble = true,
      -- Keep LuaSnip available globally, but disable go.nvim's built-in snippets
      -- because they currently hard-depend on guihua internals.
      luasnip = false,
    })

    -- Run Go binary install/update once per Neovim session
    vim.api.nvim_create_autocmd("User", {
      pattern = "GuiEnter",
      callback = function()
        vim.fn.timer_start(100, function()
          require("go.install").update_all_sync()
        end)
      end,
      once = true,
    })
  end,
}
