-- Journal.nvim https://github.com/jakobkhansen/journal.nvim

-- Weekly Summary Generator for Journal.nvim
-- Extracts 'Summary' sections from daily journals and combines them into weekly summaries
local journal_summary = {}

-- Function to get the Monday of the current week
local function get_monday_of_week()
  local today = os.date("*t")
  local days_since_monday = (today.wday - 2) % 7  -- Monday = 0, Sunday = 6
  local monday = os.time(today) - (days_since_monday * 24 * 60 * 60)
  return os.date("*t", monday)
end

-- Function to get all dates in the current week (Monday to Sunday)
local function get_week_dates()
  local monday = get_monday_of_week()
  local dates = {}
  
  for i = 0, 6 do
    local date = os.time(monday) + (i * 24 * 60 * 60)
    table.insert(dates, os.date("*t", date))
  end
  
  return dates
end

-- Function to construct the journal file path for a given date
local function get_journal_path(date)
  local journal_root = vim.fn.expand("~/.journal")
  local year = string.format("%04d", date.year)
  local month = string.format("%02d", date.month)
  local month_name = os.date("%B", os.time(date))
  local day = string.format("%02d", date.day)
  local day_name = os.date("%A", os.time(date))
  
  local path = journal_root .. "/" .. year .. "/" .. month .. "-" .. month_name .. "/daily/" .. day .. "-" .. day_name .. ".md"
  return path
end

-- Function to extract summary section from a journal file
local function extract_summary(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end
  
  local content = file:read("*all")
  file:close()
  
  -- Find the Summary section
  local summary_start = content:find("## Summary")
  if not summary_start then
    return nil
  end
  
  -- Find the content after "## Summary" line
  local summary_line_end = content:find("\n", summary_start)
  if not summary_line_end then
    return nil
  end
  
  -- Find the next section (any line starting with ##) or end of file
  local next_section = content:find("\n##", summary_line_end + 1)
  local summary_end = next_section and (next_section - 1) or #content
  
  -- Extract only the content between "## Summary" and the next section
  local summary_content = content:sub(summary_line_end + 1, summary_end)
  
  -- Extract bullet points (lines starting with - or *)
  local bullets = {}
  for line in summary_content:gmatch("[^\r\n]+") do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed:match("^[-*]%s+") and trimmed ~= "- " and trimmed ~= "* " then
      -- Clean up the bullet point
      local bullet = trimmed:gsub("^[-*]%s+", "")
      if bullet and bullet ~= "" then
        table.insert(bullets, bullet)
      end
    end
  end
  
  return bullets
end

-- Function to get the weekly journal path
local function get_weekly_journal_path()
  local monday = get_monday_of_week()
  local journal_root = vim.fn.expand("~/.journal")
  local year = string.format("%04d", monday.year)
  local month = string.format("%02d", monday.month)
  local month_name = os.date("%B", os.time(monday))
  local week_num = os.date("%W", os.time(monday))
  
  local path = journal_root .. "/" .. year .. "/" .. month .. "-" .. month_name .. "/weekly/week-" .. week_num .. ".md"
  return path
end

-- Function to generate weekly journal content
local function generate_weekly_journal(weekly_summaries)
  local weekly_path = get_weekly_journal_path()
  
  -- Create directory if it doesn't exist
  local dir = vim.fn.fnamemodify(weekly_path, ":h")
  vim.fn.mkdir(dir, "p")
  
  -- Generate fresh weekly content
  local monday = get_monday_of_week()
  local sunday_date = os.time(monday) + (6 * 24 * 60 * 60)
  local monday_str = os.date("%A %d/%m", os.time(monday))
  local sunday_str = os.date("%A %d/%m", sunday_date)
  local week_num = os.date("%W", os.time(monday))
  
  -- Start with fresh template
  local content = string.format("# Week %s - %s -> %s\n\n## Weekly Goals\n\n- [ ] \n\n## Notes\n\n", 
                                week_num, monday_str, sunday_str)
  
  -- Build the summary content with daily breakdowns and full summary
  local summary_content = "## Weekly Summary\n\n"
  local all_bullets = {}  -- Collect all bullets for the full summary
  
  -- Days of week in order
  local days_order = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
  
  -- Add daily summaries
  for _, day_name in ipairs(days_order) do
    local bullets = weekly_summaries[day_name]
    if bullets and #bullets > 0 then
      summary_content = summary_content .. "### " .. day_name .. "\n\n"
      for _, bullet in ipairs(bullets) do
        summary_content = summary_content .. "- " .. bullet .. "\n"
        table.insert(all_bullets, bullet)  -- Add to full summary
      end
      summary_content = summary_content .. "\n"
    end
  end
  
  -- Add the full summary section if we have any bullets
  if #all_bullets > 0 then
    summary_content = summary_content .. "### Full Summary\n\n"
    for _, bullet in ipairs(all_bullets) do
      summary_content = summary_content .. "- " .. bullet .. "\n"
    end
    summary_content = summary_content .. "\n"
  end
  
  -- Combine template with summary
  content = content .. "\n" .. summary_content
  
  -- Write the complete new content (replaces any existing file)
  if #all_bullets > 0 then
    local output_file = io.open(weekly_path, "w")
    output_file:write(content)
    output_file:close()
    
    -- Open the weekly journal
    vim.cmd("edit " .. weekly_path)
    print("Weekly summary regenerated with " .. #all_bullets .. " total items: " .. weekly_path)
  else
    -- Still create the file with template even if no summaries found
    local output_file = io.open(weekly_path, "w")
    output_file:write(content)
    output_file:close()
    
    vim.cmd("edit " .. weekly_path)
    print("Weekly template created (no summaries found): " .. weekly_path)
  end
end

-- Main function to generate weekly summary
function journal_summary.generate_weekly_summary()
  local week_dates = get_week_dates()
  local weekly_summaries = {}
  
  for _, date in ipairs(week_dates) do
    local journal_path = get_journal_path(date)
    local day_name = os.date("%A", os.time(date))
    
    if vim.fn.filereadable(journal_path) == 1 then
      local summaries = extract_summary(journal_path)
      if summaries and #summaries > 0 then
        weekly_summaries[day_name] = summaries
      end
    end
  end
  
  generate_weekly_journal(weekly_summaries)
end

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
    { "\\gws", function() journal_summary.generate_weekly_summary() end, desc = "Generate Weekly Summary" },
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
      template = '# %A %B %d %Y\n\n## Tasks\n\n- [ ] \n\n## Notes\n\n## Summary\n\n- \n\n',
      frequency = { day = 1 },
      
      -- Nested configurations for different entry types
      entries = {
        day = {
          format = '%Y/%m-%B/daily/%d-%A',
          template = '# %A %B %d %Y\n\n## Tasks\n\n- [ ] \n\n## Notes\n\n## Summary\n\n- \n\n## Reflection\n\n',
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