-- Arrow (like harpoon) https://github.com/otavioschwanck/arrow.nvim

return {
    src = "https://github.com/otavioschwanck/arrow.nvim",
    name = "arrow.nvim",
    setup = function()
      require("arrow").setup({
        show_icons = true,  -- show filetype icons
        leader_key = "<leader>a",  -- default keybinding prefix
        window = {
          border = "rounded",  -- nice floating window style
        },
        mappings = {
          edit = "<CR>",       -- open file
          delete = "dd",       -- remove from list
          rename = "r",        -- rename entry
        },
      })
        
      -- Set keybinds
      vim.keymap.set("n", ";", function()
      require("arrow.persist").toggle()
      end, { desc = "Toggle Arrow menu"})

    end
}