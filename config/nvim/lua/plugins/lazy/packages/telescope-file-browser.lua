-- Telescope file browser https://github.com/nvim-telescope/telescope-file-browser.nvim

return {
    enabled = false,
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("file_browser")
  
      -- Optional: Keymap to open file browser
      vim.keymap.set("n", "<leader>fb", function()
        require("telescope").extensions.file_browser.file_browser({
          path = "%:p:h",
          select_buffer = true,
        })
      end, { desc = "Telescope File Browser" })
    end,
}
  