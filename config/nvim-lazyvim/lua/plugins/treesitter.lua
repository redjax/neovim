return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Run :TSUpdate after installing/updating treesitter.
    build = ":TSUpdate",
    opts = function(_, opts)
      -- Ensure opts.ensure_installed exists before extending
      opts.ensure_installed = opts.ensure_installed or {}
      
      -- Extend the default treesitter parsers
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },
}