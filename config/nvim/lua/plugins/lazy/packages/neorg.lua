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
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-neorg/neorg-telescope"
    },
    version = "*", -- Latest stable
    -- lazy = false, -- optional: disables lazy loading for troubleshooting
    config = function()
      -- Global keymap: <leader>jt opens orgfiles workspace and today's journal
      vim.keymap.set("n", "<leader>jt", "<cmd>Neorg workspace orgfiles<CR><cmd>Neorg journal today<CR>", { noremap = true, silent = true })

      -- Register global which-key label for <leader>jt if which-key installed (new spec)
      do
        local ok, wk = pcall(require, "which-key")
        if ok then
          if wk.add then
            wk.add({
              { "<leader>jt", "Open today's Neorg journal" },
            }, {
              mode = "n",
            })
          else
            wk.register({
              { "<leader>jt", "Open today's Neorg journal" },
            }, {
              mode = "n",
            })
          end
        end
      end

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
          ["core.integrations.telescope"] = {}, -- Telescope integration for fuzzy searching notes/headlines
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

                -- Quick search workspace headlines with Telescope
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
    end,
  },
}
