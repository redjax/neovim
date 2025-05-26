-- nvim-web-devicons https://github.com/nvim-tree/nvim-web-devicons

return {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 900,
    config = function()
      require("nvim-web-devicons").setup({
        -- enable different highlight colors per icon
        color_icons = true,
        -- enable default icons for unknown filetypes
        default = true,
        -- strict matching by filename/extension
        strict = true,
      })
    end,
}
