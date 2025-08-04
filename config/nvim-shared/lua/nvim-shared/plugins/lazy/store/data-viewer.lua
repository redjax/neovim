-- Data viewer (CSV, TSV) https://github.com/VidocqH/data-viewer.nvim

return {
    "VidocqH/data-viewer.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Optional: For SQLite table support
      "kkharji/sqlite.lua",
    },
    opts = {
      -- Optional: customize config here, or leave empty for defaults
      -- autoDisplayWhenOpenFile = false,
      -- maxLineEachTable = 100,
      -- columnColorEnable = true,
      -- view = { float = true, width = 0.8, height = 0.8, zindex = 50 },
      -- keymap = { quit = "q", next_table = "<C-l>", prev_table = "<C-h>" },
    },
    -- Lazy-load on command
    cmd = { "DataViewer", "DataViewerNextTable", "DataViewerPrevTable", "DataViewerClose" },
  }
  