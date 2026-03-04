-- Configure venv-selector with fd or find fallback (silent)
-- VenvSelect comes from LazyVim's Python extras

return {
  {
    "linux-cultist/venv-selector.nvim",
    optional = true,
    opts = function(_, opts)
      local has_fd = vim.fn.executable("fd") == 1
      local has_fdfind = vim.fn.executable("fdfind") == 1
      local has_find = vim.fn.executable("find") == 1
      
      if has_fdfind then
        opts.fd_binary_name = "fdfind"
      elseif has_fd then
        opts.fd_binary_name = "fd"
      elseif has_find then
        opts.fd_binary_name = "find"
      else
        -- No suitable binary found, disable silently
        return vim.tbl_extend("force", opts, { enabled = false })
      end
      
      return opts
    end,
  },
}
