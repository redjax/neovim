-- LSP Signature (wrapper to match pattern)
return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  config = function()
    require("lsp_signature").setup({
      bind = true,
      handler_opts = { border = "rounded" },
      floating_window = true,
      hint_enable = true,
      hint_prefix = "🐼 ",
      floating_window_above_cur_line = true,
    })
  end,
}
