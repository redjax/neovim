-- Neorg (neo org-mode) https://github.com/nvim-neorg/neorg

-- Helper: get current week info to avoid duplicating this calculation
local function get_week_info()
  local today = os.date("*t")
  local year = today.year
  local month = string.format("%02d", today.month)
  local day = string.format("%02d", today.day)

  local first_of_month = os.time{year=year, month=today.month, day=1}
  local first_wday = os.date("*t", first_of_month).wday
  -- Adjust for Monday start
  local first_monday = (first_wday == 1) and 7 or first_wday - 1
  local week_of_month = math.ceil((today.day + first_monday - 1) / 7)

  local week_dir = vim.fn.expand("~/.orgfiles/journal/" .. year .. "/" .. month .. "/week-" .. week_of_month)
  local month_name = os.date("%B", os.time{year=year, month=today.month, day=1})

  return {
    year = year,
    month = today.month,
    month_str = month,
    day = day,
    week = week_of_month,
    week_dir = week_dir,
    month_name = month_name,
  }
end

-- Helper: convert a single line of Neorg syntax to Markdown
local function convert_neorg_to_markdown(line)
  local converted = line

  -- Convert headers (most asterisks first)
  for level = 6, 1, -1 do
    local stars = string.rep("%*", level)
    local pattern = "^" .. stars .. "%s+(.+)"
    if string.match(converted, pattern) then
      converted = string.rep("#", level) .. " " .. string.match(converted, pattern)
      return converted
    end
  end

  -- Convert list items (dashes)
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

  -- Bold: *word*
  converted = string.gsub(converted, "(%s)%*([^%*%s][^%*]-)%*(%s)", "%1**%2**%3")
  converted = string.gsub(converted, "^%*([^%*%s][^%*]-)%*(%s)", "**%1**%2")
  converted = string.gsub(converted, "(%s)%*([^%*%s][^%*]-)%*$", "%1**%2**")

  -- Italic: /word/ (not paths)
  converted = string.gsub(converted, "(%s)/([^/%s][^/]-)/(%s)", "%1*%2*%3")
  converted = string.gsub(converted, "^/([^/%s][^/]-)/(%s)", "*%1*%2")
  converted = string.gsub(converted, "(%s)/([^/%s][^/]-)/$", "%1*%2*")

  -- Links: {text}[url]
  converted = string.gsub(converted, "{([^}]+)}%[([^%]]+)%]", "[%1](%2)")

  return converted
end

return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = false, -- Track latest commit; semver releases can lag behind
    rocks = { "lua-utils.nvim", "pathlib.nvim" },
    -- Auto-compile norg treesitter parsers on install/update
    build = function(plugin)
      if vim.fn.executable("gcc") ~= 1 or vim.fn.executable("g++") ~= 1 then
        vim.notify("[neorg] gcc/g++ not found — norg treesitter parsers not compiled", vim.log.levels.WARN)
        return
      end

      local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
      vim.fn.mkdir(parser_dir, "p")

      -- Read parser revisions from neorg's own source so they stay in sync
      local ts_mod = plugin.dir .. "/lua/neorg/modules/core/integrations/treesitter/module.lua"
      local content = table.concat(vim.fn.readfile(ts_mod), "\n")
      local norg_rev = content:match('norg = {.-revision = "([^"]+)"')
      local meta_rev = content:match('norg_meta = {.-revision = "([^"]+)"')

      -- Build norg parser
      local tmp = vim.fn.tempname()
      vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/nvim-neorg/tree-sitter-norg.git", tmp })
      if norg_rev then vim.fn.system({ "git", "-C", tmp, "fetch", "--depth", "1", "origin", norg_rev }) end
      if norg_rev then vim.fn.system({ "git", "-C", tmp, "checkout", norg_rev }) end
      vim.fn.system({ "gcc", "-c", "-fPIC", "-O2", "-I", tmp .. "/src", tmp .. "/src/parser.c", "-o", tmp .. "/parser.o" })
      vim.fn.system({ "g++", "-c", "-fPIC", "-O2", "-I", tmp .. "/src", tmp .. "/src/scanner.cc", "-o", tmp .. "/scanner.o" })
      vim.fn.system({ "g++", "-shared", "-o", parser_dir .. "/norg.so", tmp .. "/parser.o", tmp .. "/scanner.o" })
      vim.fn.delete(tmp, "rf")

      -- Build norg_meta parser
      tmp = vim.fn.tempname()
      vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/nvim-neorg/tree-sitter-norg-meta.git", tmp })
      if meta_rev then vim.fn.system({ "git", "-C", tmp, "fetch", "--depth", "1", "origin", meta_rev }) end
      if meta_rev then vim.fn.system({ "git", "-C", tmp, "checkout", meta_rev }) end
      vim.fn.system({ "gcc", "-shared", "-fPIC", "-O2", "-I", tmp .. "/src", tmp .. "/src/parser.c", "-o", parser_dir .. "/norg_meta.so" })
      vim.fn.delete(tmp, "rf")
    end,
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},            -- Icons & LaTeX support
          ["core.export"] = {},               -- Export .norg files
          ["core.export.markdown"] = {},      -- Export to Markdown
          ["core.dirman"] = {                 -- Workspace management
            config = {
              workspaces = {
                orgfiles = "~/.orgfiles",
                notes = "~/.orgfiles/notes",
                journal = "~/.orgfiles/journal",
              },
              default_workspace = "orgfiles",
            },
          },
          ["core.esupports.metagen"] = {},    -- Autogenerate metadata
          ["core.summary"] = {},              -- Structured workspace summaries
          ["core.journal"] = {
            config = {
              strategy = "nested",            -- year/month/day directory hierarchy
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,

              hook = function(keybinds)
                -- Unmap conflicting defaults
                keybinds.unmap("norg", "n", "<localleader>cm")
                keybinds.unmap("norg", "n", "gO")
                keybinds.unmap("norg", "n", "gT")
                keybinds.unmap("norg", "n", "<localleader>tj")

                -- Remap TOC
                keybinds.map("norg", "n", "gT", "<cmd>Neorg toc<CR>")

                -- Magnify code block
                keybinds.map("norg", "n", "<localleader>cx", "<Plug>(neorg.looking-glass.magnify-code-block)")

                -- Journal placeholder (handled by global keymap below)
                keybinds.map("norg", "n", "<localleader>tj", function() end)

                -- Toggle concealer icons
                keybinds.map("norg", "n", "<localleader>ic", "<cmd>Neorg toggle-concealer<CR>")

                -- Open default workspace
                keybinds.map("norg", "n", "<localleader>wo", "<cmd>Neorg workspace orgfiles<CR>")

                -- Register with which-key if available
                local ok, wk = pcall(require, "which-key")
                if ok and wk.add then
                  wk.add({
                    { "<localleader>t", group = "journal" },
                    { "<localleader>tj", desc = "Open today's journal" },
                    { "<localleader>gws", desc = "Generate weekly summary" },
                    { "<localleader>gwm", desc = "Generate weekly summary (MD)" },
                    { "<localleader>wo", desc = "Open default workspace" },
                  }, {
                    mode = "n",
                    buffer = vim.api.nvim_get_current_buf(),
                  })
                end
              end,
            },
          },
        },
      })

      -- Journal: open today's entry (year/month/week/day structure)
      vim.keymap.set("n", "<localleader>tj", function()
        local info = get_week_info()
        local journal_file = info.week_dir .. "/" .. info.day .. ".norg"

        vim.cmd("Neorg workspace orgfiles")
        vim.fn.mkdir(info.week_dir, "p")
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
            local heading = "* " .. os.date("%Y-%m-%d (%A)")
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { heading, "", "" })
            vim.api.nvim_win_set_cursor(0, { 3, 0 })
          end
        end)

        print("Journal: " .. info.month_name .. " Week " .. info.week .. ", Day " .. info.day)
      end, { noremap = true, silent = true, desc = "Open today's journal (year/month/week/day)" })

      -- Weekly summary (.norg)
      vim.keymap.set("n", "<localleader>gws", function()
        local info = get_week_info()
        local summary_path = info.week_dir .. "/week-summary.norg"

        if vim.fn.isdirectory(info.week_dir) == 0 then
          print("[ERROR] Week directory doesn't exist: " .. info.week_dir)
          return
        end

        local files = vim.fn.globpath(info.week_dir, "[0-9][0-9].norg", false, true)
        if #files == 0 then
          print("[ERROR] No daily files found in: " .. info.week_dir)
          return
        end

        table.sort(files)

        local summary = {
          "* " .. info.month_name .. " Week " .. info.week .. " Summary (" .. info.year .. ")",
          "** " .. os.date("%B %d, %Y") .. " - Week Overview",
          "",
        }

        for _, file in ipairs(files) do
          local day = vim.fn.fnamemodify(file, ":t:r")
          local lines = vim.fn.readfile(file)
          local day_num = tonumber(day)
          local day_date = os.date("%A, %B %d", os.time{year=info.year, month=info.month, day=day_num})

          table.insert(summary, "*** " .. day_date)

          local found_content = false
          for _, line in ipairs(lines) do
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
        print("Weekly summary written to: " .. summary_path)
        vim.cmd("edit " .. summary_path)
      end, { noremap = true, silent = true, desc = "Generate weekly summary for current week" })

      -- Weekly summary (Markdown)
      vim.keymap.set("n", "<localleader>gwm", function()
        local info = get_week_info()
        local summary_path = info.week_dir .. "/week-summary.md"

        if vim.fn.isdirectory(info.week_dir) == 0 then
          print("[ERROR] Week directory doesn't exist: " .. info.week_dir)
          return
        end

        local files = vim.fn.globpath(info.week_dir, "[0-9][0-9].norg", false, true)
        if #files == 0 then
          print("[ERROR] No daily files found in: " .. info.week_dir)
          return
        end

        table.sort(files)

        local summary = {
          "# " .. info.month_name .. " Week " .. info.week .. " Summary (" .. info.year .. ")",
          "## " .. os.date("%B %d, %Y") .. " - Week Overview",
          "",
        }

        for _, file in ipairs(files) do
          local day = vim.fn.fnamemodify(file, ":t:r")
          local lines = vim.fn.readfile(file)
          local day_num = tonumber(day)
          local day_date = os.date("%A, %B %d", os.time{year=info.year, month=info.month, day=day_num})

          table.insert(summary, "### " .. day_date)

          local found_content = false
          for _, line in ipairs(lines) do
            if line:match("%S") and not line:match("^%* %d%d%d%d%-%d%d%-%d%d") then
              table.insert(summary, convert_neorg_to_markdown(line))
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

        vim.schedule(function()
          vim.bo[vim.api.nvim_get_current_buf()].filetype = "markdown"
        end)
      end, { noremap = true, silent = true, desc = "Generate weekly summary as Markdown" })
    end,
  },
}
