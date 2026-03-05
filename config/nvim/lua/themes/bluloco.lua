-- Bluloco themes https://github.com/uloco/bluloco.nvim

return {
    "uloco/bluloco.nvim",
    lazy = true,  -- Let Themery manage loading
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      require("bluloco").setup({
        style = "dark", -- "auto" | "dark" | "light"
        transparent = false,
        italics = false,
        terminal = vim.fn.has("gui_running") == 1,
        guicursor = true,
      })
    end,
}
