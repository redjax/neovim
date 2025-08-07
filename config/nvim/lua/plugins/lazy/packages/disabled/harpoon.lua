-- Harpoon https://github.com/ThePrimeagen/harpoon
return {
  "ThePrimeagen/harpoon",
  branch = "master", -- or specify a tag/commit if needed
  lazy = false,      -- set to true if you want to load it on demand
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon").setup({
      menu = {
        width = vim.api.nvim_win_get_width(0) - 20,
      },
      global_settings = {
        save_on_toggle = true,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
      },
    })

    -- Optional keybindings
    local harpoon_mark = require("harpoon.mark")
    local harpoon_ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", harpoon_mark.add_file, { desc = "Harpoon: Add file" })
    vim.keymap.set("n", "<C-e>", harpoon_ui.toggle_quick_menu, { desc = "Harpoon: Toggle menu" })
    vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end)
    vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end)
    vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end)
    vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end)
  end,
}
