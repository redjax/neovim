-- Neorg (neo org-mode) https://github.com/vhyrro/luarocks.nvim

return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Load before neorg
    config = true,   -- Runs require("luarocks-nvim").setup()
  },
  {
    "nvim-neorg/neorg",
    lazy = false, -- Load immediately so keybindings are always available
    priority = 999,  -- Load after luarocks but before most other plugins
    dependencies = {
      "luarocks.nvim",
      "nvim-telescope/telescope.nvim",          -- keep if you later re-enable integrations
      "nvim-neorg/neorg-telescope"              -- required for core.integrations.telescope
    },
    version = "*", -- Latest stable; consider pinning if integration mismatches occur
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {}, -- Icons & LaTeX support
          ["core.export"] = {}, -- Allows you to export .norg files
          ["core.export.markdown"] = {}, -- Export directly to Markdown
          ["core.dirman"] = { -- Workspace management
            config = {
              workspaces = { orgfiles = "~/.orgfiles", notes = "~/.orgfiles/notes", journal = "~/.orgfiles/journal" },
              default_workspace = "orgfiles",
            },
          },
          ["core.esupports.metagen"] = {}, -- Autogenerate metadata for notes
          ["core.integrations.telescope"] = {}, -- Telescope integration (disabled until neorg-telescope matches)
          ["core.summary"] = {}, -- Lets you view structured summaries of a workspace
          ["core.journal"] = {
            config = {
              strategy = "nested" -- "flat" or "nested" (directory hierarchy)
            }
          },
          ["core.keybinds"] = {
            -- Configure keybinds
            config = {
              default_keybinds = true,

              hook = function(keybinds)
                -- Determine if which-key is installed
                local ok, wk = pcall(require, "which-key")

                -- Unmap conflicting keys so Neorg won't bind them
                keybinds.unmap("norg", "n", "<localleader>cm") -- unbind magnify-code-block
                keybinds.unmap("norg", "n", "gO") -- unbind toc key
                keybinds.unmap("norg", "n", "gT")
                keybinds.unmap("norg", "n", "<localleader>tj")

                -- Remap TOC
                keybinds.map("norg", "n", "gT", "<cmd>Neorg toc<CR>")

                -- For magnify code block, remap to <localleader>cx
                keybinds.map("norg", "n", "<localleader>cx", "<Plug>(neorg.looking-glass.magnify-code-block)")

                -- Open today's daily note quickly (buffer-local), uses month/week structure
                keybinds.map("norg", "n", "<localleader>tj", function() end) -- Handled by keymap below

                -- Toggle concealer icons (for quick plain view)
                keybinds.map("norg", "n", "<localleader>ic", "<cmd>Neorg toggle-concealer<CR>")

                -- Quick search workspace headlines with Telescope (will work once integration is re-enabled)
                keybinds.map("norg", "n", "<localleader>sh", "<cmd>Telescope neorg headlines<CR>")

                -- Optionally: open the default workspace via a Neorg-local binding
                keybinds.map("norg", "n", "<localleader>wo", "<cmd>Neorg workspace orgfiles<CR>")

                -- Add keybinds to which-key if it's installed (buffer-local, new spec)
                if ok then
                  local buf = vim.api.nvim_get_current_buf()
                  if wk.add then
                    wk.add({
                      { "<localleader>t", name = "journal" },                -- group header
                      { "<localleader>tj", "Open today's journal" },        -- description
                      { "<localleader>gws", "Generate weekly summary" },    -- weekly summary
                      { "<localleader>gwm", "Generate weekly summary (MD)" }, -- markdown summary
                      { "<localleader>wo", "Open default workspace" },      -- new workspace launcher
                    }, {
                      mode = "n",
                      buffer = buf,
                    })
                  else
                    wk.register({
                      { "<localleader>t", name = "journal" },
                      { "<localleader>tj", "Open today's journal" },
                      { "<localleader>gws", "Generate weekly summary" },
                      { "<localleader>gwm", "Generate weekly summary (MD)" },
                      { "<localleader>wo", "Open default workspace" },
                    }, {
                      mode = "n",
                      buffer = buf,
                    })
                  end
                end
              end,
            },
          },
        },
      })

      -- Main journal function - year/month/week/day structure
      vim.keymap.set("n", "<localleader>tj", function()
        local today = os.date("*t")
        local year = today.year
        local month = string.format("%02d", today.month)
        local day = string.format("%02d", today.day)
        
        -- Calculate which week of the month this is
        local first_of_month = os.time{year=year, month=today.month, day=1}
        local first_wday = os.date("*t", first_of_month).wday
        
        -- Adjust for Monday start
        local first_monday = (first_wday == 1) and 7 or first_wday - 1
        local week_of_month = math.ceil((today.day + first_monday - 1) / 7)
        
        -- Create month/week path: ~/.orgfiles/journal/2025/09/week-1/02.norg
        local week_dir = vim.fn.expand("~/.orgfiles/journal/" .. year .. "/" .. month .. "/week-" .. week_of_month)
        local journal_file = week_dir .. "/" .. day .. ".norg"
        
        -- Ensure workspace is set
        vim.cmd("Neorg workspace orgfiles")
        
        -- Create directory if it doesn't exist
        vim.fn.mkdir(week_dir, "p")
        
        -- Open the file
        vim.cmd("edit " .. journal_file)
        
        vim.schedule(function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype ~= "norg" then
            return
          end
          
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local is_blank = true
          for _, l in ipairs(lines) do
            if l:match("%S") then
              is_blank = false
              break
            end
          end
          
          if is_blank then
            local date_str = os.date("%Y-%m-%d (%A)")
            local heading = "* " .. date_str
            
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 
              heading, 
              "", 
              "" 
            })
            vim.api.nvim_win_set_cursor(0, { 3, 0 })
          end
        end)
        
        local month_name = os.date("%B")
        print("📅 Journal: " .. month_name .. " Week " .. week_of_month .. ", Day " .. day)
      end, { noremap = true, silent = true, desc = "Open today's journal (year/month/week/day)" })

      -- Weekly summary for year/month/week/day structure
      vim.keymap.set("n", "<localleader>gws", function()
        local today = os.date("*t")
        local year = today.year
        local month = string.format("%02d", today.month)
        
        -- Calculate current week of month
        local first_of_month = os.time{year=year, month=today.month, day=1}
        local first_wday = os.date("*t", first_of_month).wday
        local first_monday = (first_wday == 1) and 7 or first_wday - 1
        local week_of_month = math.ceil((today.day + first_monday - 1) / 7)
        
        local week_dir = vim.fn.expand("~/.orgfiles/journal/" .. year .. "/" .. month .. "/week-" .. week_of_month)
        local summary_path = week_dir .. "/week-summary.norg"
        
        if not vim.fn.isdirectory(week_dir) then
          print("[ERROR] Week directory doesn't exist: " .. week_dir)
          return
        end
        
        local files = vim.fn.globpath(week_dir, "[0-9][0-9].norg", false, true)
        
        if #files == 0 then
          print("[ERROR] No daily files found in: " .. week_dir)
          return
        end
        
        table.sort(files)
        
        local month_name = os.date("%B", os.time{year=year, month=today.month, day=1})
        local summary = { 
          "* " .. month_name .. " Week " .. week_of_month .. " Summary (" .. year .. ")",
          "** " .. os.date("%B %d, %Y") .. " - Week Overview",
          ""
        }
        
        for _, file in ipairs(files) do
          local day = vim.fn.fnamemodify(file, ":t:r")
          local lines = vim.fn.readfile(file)
          
          -- Get the actual date for this day number
          local day_num = tonumber(day)
          local day_date = os.date("%A, %B %d", os.time{year=year, month=today.month, day=day_num})
          
          table.insert(summary, "*** " .. day_date)
          
          local found_content = false
          for _, line in ipairs(lines) do
            -- Skip headers and empty lines, include actual content
            if line:match("%S") and not line:match("^%*+%s") and not line:match("Week%s") then
              table.insert(summary, line)
              found_content = true
            end
          end
          
          if not found_content then
            table.insert(summary, "No entries for this day.")
          end
          
          table.insert(summary, "")
        end
        
        vim.fn.writefile(summary, summary_path)
        print("✅ Weekly summary written to: " .. summary_path)
        vim.cmd("edit " .. summary_path)
      end, { noremap = true, silent = true, desc = "Generate weekly summary for current week" })

      -- Weekly summary as Markdown
      vim.keymap.set("n", "<localleader>gwm", function()
        local today = os.date("*t")
        local year = today.year
        local month = string.format("%02d", today.month)
        
        -- Calculate current week of month
        local first_of_month = os.time{year=year, month=today.month, day=1}
        local first_wday = os.date("*t", first_of_month).wday
        local first_monday = (first_wday == 1) and 7 or first_wday - 1
        local week_of_month = math.ceil((today.day + first_monday - 1) / 7)
        
        local week_dir = vim.fn.expand("~/.orgfiles/journal/" .. year .. "/" .. month .. "/week-" .. week_of_month)
        local summary_path = week_dir .. "/week-summary.md"
        
        if not vim.fn.isdirectory(week_dir) then
          print("[ERROR] Week directory doesn't exist: " .. week_dir)
          return
        end
        
        local files = vim.fn.globpath(week_dir, "[0-9][0-9].norg", false, true)
        
        if #files == 0 then
          print("[ERROR] No daily files found in: " .. week_dir)
          return
        end
        
        table.sort(files)
        
        local month_name = os.date("%B", os.time{year=year, month=today.month, day=1})
        local summary = { 
          "# " .. month_name .. " Week " .. week_of_month .. " Summary (" .. year .. ")",
          "## " .. os.date("%B %d, %Y") .. " - Week Overview",
          ""
        }
        
        local function convert_neorg_to_markdown(line)
          local converted = line
          
          -- Only convert actual Neorg syntax, don't mess with regular text
          
          -- Convert headers (only if they start with asterisks)
          if string.match(converted, "^%*%*%*%*%*%*%s+") then
            converted = string.gsub(converted, "^%*%*%*%*%*%*%s+(.+)", "###### %1")
          elseif string.match(converted, "^%*%*%*%*%*%s+") then
            converted = string.gsub(converted, "^%*%*%*%*%*%s+(.+)", "##### %1")
          elseif string.match(converted, "^%*%*%*%*%s+") then
            converted = string.gsub(converted, "^%*%*%*%*%s+(.+)", "#### %1")
          elseif string.match(converted, "^%*%*%*%s+") then
            converted = string.gsub(converted, "^%*%*%*%s+(.+)", "### %1")
          elseif string.match(converted, "^%*%*%s+") then
            converted = string.gsub(converted, "^%*%*%s+(.+)", "## %1")
          elseif string.match(converted, "^%*%s+") then
            converted = string.gsub(converted, "^%*%s+(.+)", "# %1")
          end
          
          -- Convert list items (only if they start with dashes)
          if string.match(converted, "^%-+%s+") then
            for level = 10, 1, -1 do
              local dashes = string.rep("-", level)
              local pattern = "^" .. dashes .. "(%s+)"
              if string.match(converted, pattern) then
                local indent = string.rep("  ", level - 1)
                converted = string.gsub(converted, pattern, indent .. "- ")
                break
              end
            end
          end
          
          -- Only convert formatting if it looks like actual Neorg syntax
          -- Bold: *word* but not in the middle of text
          converted = string.gsub(converted, "(%s)%*([^%*%s][^%*]-)%*(%s)", "%1**%2**%3")
          converted = string.gsub(converted, "^%*([^%*%s][^%*]-)%*(%s)", "**%1**%2")
          converted = string.gsub(converted, "(%s)%*([^%*%s][^%*]-)%*$", "%1**%2**")
          
          -- Italic: /word/ but not in paths
          converted = string.gsub(converted, "(%s)/([^/%s][^/]-)/(%s)", "%1*%2*%3")
          converted = string.gsub(converted, "^/([^/%s][^/]-)/(%s)", "*%1*%2")
          converted = string.gsub(converted, "(%s)/([^/%s][^/]-)/$", "%1*%2*")
          
          -- Links: {text}[url]
          converted = string.gsub(converted, "{([^}]+)}%[([^%]]+)%]", "[%1](%2)")
          
          return converted
        end
        
        for _, file in ipairs(files) do
          local day = vim.fn.fnamemodify(file, ":t:r")
          local lines = vim.fn.readfile(file)
          
          -- Get the actual date for this day number
          local day_num = tonumber(day)
          local day_date = os.date("%A, %B %d", os.time{year=year, month=today.month, day=day_num})
          
          table.insert(summary, "### " .. day_date)
          
          local found_content = false
          for _, line in ipairs(lines) do
            -- Skip the date headers, but include other content
            if line:match("%S") and not line:match("^%* %d%d%d%d%-%d%d%-%d%d") then
              local converted_line = convert_neorg_to_markdown(line)
              table.insert(summary, converted_line)
              found_content = true
            end
          end
          
          if not found_content then
            table.insert(summary, "No entries for this day.")
          end
          
          table.insert(summary, "")
        end
        
        vim.fn.writefile(summary, summary_path)
        print("Weekly summary (Markdown) written to: " .. summary_path)
        vim.cmd("edit " .. summary_path)
        
        -- Set the buffer to markdown filetype
        vim.schedule(function()
          local buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].filetype = "markdown"
        end)
      end, { noremap = true, silent = true, desc = "Generate weekly summary as Markdown" })

    end,
  },
}
