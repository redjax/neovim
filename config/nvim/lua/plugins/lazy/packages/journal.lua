-- Journal.nvim https://github.com/jakobkhansen/journal.nvim

return {
  "jakobkhansen/journal.nvim",
  cmd = "Journal",
  keys = {
    { "<leader>jj", "<cmd>Journal<cr>", desc = "Open today's journal" },
    { "<leader>jd", "<cmd>Journal day<cr>", desc = "Open daily journal" },
    { "<leader>jw", "<cmd>Journal week<cr>", desc = "Open weekly journal" },
    { "<leader>jm", "<cmd>Journal month<cr>", desc = "Open monthly journal" },
    { "<leader>jy", "<cmd>Journal year<cr>", desc = "Open yearly journal" },
    { "<leader>jt", "<cmd>Journal<cr>", desc = "Today's journal" },
    { "<leader>jn", "<cmd>Journal day +1<cr>", desc = "Tomorrow's journal" },
    { "<leader>jp", "<cmd>Journal day -1<cr>", desc = "Yesterday's journal" },
  },
  opts = {
    filetype = 'md',                    -- Filetype for journal entries
    root = '~/.journal',                -- Root directory for journal entries (hidden directory)
    date_format = '%Y-%m-%d',           -- Date format for date modifiers (ISO format, Windows-compatible)
    autocomplete_date_modifier = "end", -- Enable date modifier autocompletion
    
    -- Configuration for journal entries
    journal = {
      -- Default configuration for `:Journal <date-modifier>`
      format = '%Y/%m-%B/daily/%d-%A',
      template = '# %A %B %d %Y\n\n## Tasks\n\n- [ ] \n\n## Notes\n\n',
      frequency = { day = 1 },
      
      -- Nested configurations for different entry types
      entries = {
        day = {
          format = '%Y/%m-%B/daily/%d-%A',
          template = '# %A %B %d %Y\n\n## Tasks\n\n- [ ] \n\n## Notes\n\n## Reflection\n\n',
          frequency = { day = 1 },
        },
        week = {
          format = '%Y/%m-%B/weekly/week-%W',
          template = function(date)
            local sunday = date:relative({ day = 6 })
            local end_date = os.date('%A %d/%m', os.time(sunday.date))
            return "# Week %W - %A %d/%m -> " .. end_date .. "\n\n## Weekly Goals\n\n- [ ] \n\n## Notes\n\n## Review\n\n"
          end,
          frequency = { day = 7 },
          date_modifier = "monday"
        },
        month = {
          format = '%Y/%m-%B/%B',
          template = "# %B %Y\n\n## Monthly Goals\n\n- [ ] \n\n## Projects\n\n## Review\n\n",
          frequency = { month = 1 }
        },
        year = {
          format = '%Y/%Y',
          template = "# %Y\n\n## Annual Goals\n\n- [ ] \n\n## Major Projects\n\n## Yearly Review\n\n",
          frequency = { year = 1 }
        },
        
        -- Work-specific entries
        work = {
          format = 'work/%Y/%m-%B/daily/%d-%A',
          template = '# Work Journal - %A %B %d %Y\n\n## Today\'s Tasks\n\n- [ ] \n\n## Meetings\n\n## Notes\n\n## Tomorrow\'s Prep\n\n',
          frequency = { day = 1 },
          
          entries = {
            day = {
              format = 'work/%Y/%m-%B/daily/%d-%A',
              template = '# Work - %A %B %d %Y\n\n## Tasks\n\n- [ ] \n\n## Meetings\n\n## Notes\n\n',
              frequency = { day = 1 },
            },
            week = {
              format = 'work/%Y/%m-%B/weekly/week-%W',
              template = "# Work Week %W %B %Y\n\n## Weekly Objectives\n\n- [ ] \n\n## Projects\n\n## Team Updates\n\n",
              frequency = { day = 7 },
              date_modifier = "monday"
            }
          }
        },
        
        -- Project-specific entries
        project = {
          format = 'projects/%Y/%m-%B/%d-project-notes',
          template = '# Project Notes - %A %B %d %Y\n\n## Current Project\n\n## Progress\n\n## Next Steps\n\n## Issues\n\n',
          frequency = { day = 1 }
        }
      }
    }
  },
  config = function(_, opts)
    require("journal").setup(opts)
  end,
}