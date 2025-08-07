-- Arrow (like harpoon) https://github.com/otavioschwanck/arrow.nvim

return {
  "otavioschwanck/arrow.nvim",
  config = function()
    require("arrow").setup({
      show_icons = true,  -- show filetype icons
      leader_key = "<leader>a",  -- default keybinding prefix
      window = {
        border = "rounded",  -- nice floating window style
        position = "center", -- can be "center" or "top"
      },
      mappings = {
        edit = "<CR>",       -- open file
        delete = "dd",       -- remove from list
        rename = "r",        -- rename entry
      },
    })
  end,
  event = "VeryLazy",  -- load when needed
}
