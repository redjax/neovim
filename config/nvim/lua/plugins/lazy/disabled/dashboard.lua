-- Dashboard https://github.com/nvimdev/dashboard-nvim

return {
    "nvimdev/dashboard-nvim",
    -- loads dashboard when Neovim starts
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        -- "hyper", ""doom", or "dashboard"
        theme = "hyper",
        -- Example config for "hyper" theme:
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = "Find Files", group = "@property", action = "Telescope find_files", key = "f" },
            { desc = "Live Grep", group = "@property", action = "Telescope live_grep", key = "g" },
            { desc = "Buffers", group = "@property", action = "Telescope buffers", key = "b" },
            { desc = "Recent Files", group = "@property", action = "Telescope oldfiles", key = "r" },
            { desc = "Help", group = "@property", action = "Telescope help_tags", key = "h" },
            { desc = "Lazy", group = "@property", action = "Lazy", key = "l" },
            { desc = "Quit", group = "@property", action = function() vim.cmd("qa") end, key = "q" },
          },
        },
      })
    end,
}
  