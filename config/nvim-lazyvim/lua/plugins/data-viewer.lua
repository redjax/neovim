-- Data viewer (CSV, TSV) https://github.com/VidocqH/data-viewer.nvim

return {
  "VidocqH/data-viewer.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Optional: For SQLite table support
    "kkharji/sqlite.lua",
  },
  opts = {
    -- Automatically display the table view when opening a file (default: false)
    autoDisplayWhenOpenFile = false,
    -- Maximum lines shown per table (default: 100)
    maxLineEachTable = 100,
    -- Enable color highlighting by column (default: true)
    columnColorEnable = true,
    -- Highlight groups cycling for columns
    columnColorRoulette = {
      "DataViewerColumn0",
      "DataViewerColumn1",
      "DataViewerColumn2",
    },
    -- View configuration
    view = {
      float = true,          -- Use a floating window (false uses current window)
      width = 0.8,           -- Float window width ratio (0 < width <= 1)
      height = 0.8,          -- Float window height ratio (0 < height <= 1)
      zindex = 50,           -- Floating window Z-index
    },
    -- Keymap configuration
    keymap = {
      quit = "q",            -- Quit data viewer window
      next_table = "<C-l>",  -- Next table
      prev_table = "<C-h>",  -- Previous table
    },
  },
  -- Lazy-load commands
  cmd = { "DataViewer", "DataViewerNextTable", "DataViewerPrevTable", "DataViewerClose" },
}
