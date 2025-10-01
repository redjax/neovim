-- Scrollview https://github.com/dstein64/nvim-scrollview

return {
    "dstein64/nvim-scrollview",
    event = "VeryLazy", -- or "BufWinEnter" if you want it earlier
    opts = {
      -- Optional: customize these options as needed
      -- excluded_filetypes = { "NvimTree", "neo-tree", "alpha" },
      -- current_only = true,     -- Only show scrollbar for current window
      -- base = 'buffer',        -- Base scrollbar position on buffer or window
      -- column = 80,            -- Scrollbar column position
      -- signs_on_startup = { "diagnostics", "search" }, -- or { "all" }
    },
    config = function(_, opts)
      require("scrollview").setup(opts)
    end,
}
  