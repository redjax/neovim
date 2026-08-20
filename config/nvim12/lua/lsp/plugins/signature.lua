return {
  src = "https://github.com/ray-x/lsp_signature.nvim",
  name = "lsp_signature.nvim",
  setup = function()
    require("lsp_signature").setup({
      bind = true,
      handler_opts = { border = "rounded" },
      floating_window = true,
      hint_enable = true,
      hint_prefix = "> ",
      floating_window_above_cur_line = true,
    })
  end,
}
