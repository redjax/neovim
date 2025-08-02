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
        vim.cmd("Neorg workspace orgfiles")  -- ensure workspace
        vim.cmd("Neorg journal today")
      end, { noremap = true, silent = true, desc = "Open today's Neorg journal" })

      -- NOTE: intentionally not registering a which-key description-only entry for <localleader>jt
      -- because that was causing the fallback-typing behavior. If you want to re-add it later,
      -- ensure the actual mapping works first and then, separately, register the label.

    end,
  },
}
