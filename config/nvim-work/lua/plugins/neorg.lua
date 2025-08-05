-- Neorg (neo org-mode) https://github.com/vhyrro/luarocks.nvim

return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Loads before other plugins
    config = true,   -- Runs require("luarocks-nvim").setup()
  },
  {
    "nvim-neorg/neorg",
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
              workspaces = { orgfiles = "~/.orgfiles", notes = "~/notes" },
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

                -- Open today's daily note quickly (buffer-local)
                keybinds.map("norg", "n", "<localleader>tj", "<cmd>Neorg journal today<CR>")

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
                      { "<localleader>wo", "Open default workspace" },      -- new workspace launcher
                    }, {
                      mode = "n",
                      buffer = buf,
                    })
                  else
                    wk.register({
                      { "<localleader>t", name = "journal" },
                      { "<localleader>tj", "Open today's journal" },
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

      -- Explicit localleader mapping to open today's journal (\jt)
      vim.keymap.set("n", "<localleader>jt", function()
      -- ensure workspace and open today's journal
      vim.cmd("Neorg workspace orgfiles")
      vim.cmd("Neorg journal today")

      vim.schedule(function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype ~= "norg" then
          return
        end

        -- Get current buffer contents
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local is_blank = true
        for _, l in ipairs(lines) do
          if l:match("%S") then
            is_blank = false
            break
          end
        end

        -- If it's effectively empty, seed with Neorg-style date heading
        if is_blank then
          local today = os.date("%Y-%m-%d")
          local heading = "* " .. today
          -- Insert heading + two blank lines so cursor can safely be on line 3
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, { heading, "", "" })
          -- place cursor on third line (after heading + one blank)
          vim.api.nvim_win_set_cursor(0, { 3, 0 })
        end
      end)
    end, { noremap = true, silent = true, desc = "Open today's Neorg journal and add date heading" })

      -- Keymap to generate weekly summary from daily Neorg journal entries
      vim.keymap.set("n", "<localleader>gws", function()
      local year = os.date("%Y")
      local month = os.date("%m")
      local journal_path = vim.fn.expand("~/.orgfiles/journal/" .. year .. "/" .. month)
      local summary_path = journal_path .. "/weekly-summary.norg"
      local files = vim.fn.globpath(journal_path, "*.norg", false, true)

      -- Exclude the summary file itself
      files = vim.tbl_filter(function(file)
        return not file:match("weekly%-summary%.norg$")
      end, files)

      if #files == 0 then
        print("No journal files found for this month.")
        return
      end

      table.sort(files)

      local first_day = vim.fn.fnamemodify(files[1], ":t:r")
      local last_day = vim.fn.fnamemodify(files[#files], ":t:r")
      local heading = "* Weekly Summary: " .. first_day .. " to " .. last_day

      local summary = { heading, "" }

      -- Read existing summary to detect already summarized files
      local existing_summary = {}
      if vim.fn.filereadable(summary_path) == 1 then
        existing_summary = vim.fn.readfile(summary_path)
      end

      local already_summarized = {}
      for _, line in ipairs(existing_summary) do
        local match = line:match("^%* Weekly Summary: (%d%d%d%d%-%d%d%-%d%d) to (%d%d%d%d%-%d%d%-%d%d)")
        if match then
          already_summarized[match] = true
        end
      end
      
      for _, file in ipairs(files) do
        local filename = vim.fn.fnamemodify(file, ":t:r")
        if not summary_path:match(filename) then
          local lines = vim.fn.readfile(file)
          for _, line in ipairs(lines) do
            if line:match("%S") and not line:match("^%*") and not line:match("^◉") then
              table.insert(summary, line)
            end
          end
        end
      end

      vim.fn.writefile(summary, summary_path)
      print("✅ Weekly summary written to: " .. summary_path)
      vim.cmd("edit " .. summary_path)
    end, { noremap = true, silent = true, desc = "Generate and open weekly Neorg summary" })

    end,
  },
}
