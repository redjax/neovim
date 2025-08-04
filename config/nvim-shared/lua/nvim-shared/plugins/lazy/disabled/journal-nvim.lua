-- Journal (daily, weekly, monthly, etc) https://github.com/jakobkhansen/journal.nvim

return {
  {
    "jakobkhansen/journal.nvim",
    config = function()
      require("journal").setup({
        filetype = "md",          -- default filetype for new journal entries
        root = "~/.journal",       -- default root directory for journals
        date_format = "%Y/%m/%d", -- date format for journal command

        -- Example entry type customizations:
        journal = {
          format = "%Y/%m-%B/daily/%d-%A",
          template = "# %A %B %d %Y\n",
          frequency = { day = 1 },
          entries = {
            week = {
              format = "%Y/%m-%B/weekly/week-%W",
              template = "# Week %W %B %Y\n",
              frequency = { day = 7 },
              date_modifier = "monday",
            },
          },
        },
      })
    end,
    
    -- lazy-load on :Journal command
    cmd = {"Journal"},
  },
}

