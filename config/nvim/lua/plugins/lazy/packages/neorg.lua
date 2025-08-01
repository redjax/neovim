-- Neorg (neo org-mode) https://github.com/vhyrro/luarocks.nvim

return {
  {
    enabled = true,
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Loads before other plugins
    config = true,   -- Runs require("luarocks-nvim").setup()
  },
  {
    enabled = true,
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
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {}, -- Icons & LaTeX support
          ["core.export"] = {}, -- Allows you to export .norg files
          ["core.export.markdown"] = {}, -- Export directly to Markdown
          ["core.dirman"] = { -- Workspace management
            config = {
              workspaces = { orgfiles = "~/orgfiles", notes = "~/notes" },
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
                keybinds.unmap("norg", "n", "<LocalLeader>cm") -- unbind magnify-code-block
                keybinds.unmap("norg", "n", "gO") -- unbind toc key
                keybinds.unmap("norg", "n", "gT")
                keybinds.unmap("norg", "n", "<LocalLeader>tj")

                -- Remap TOC
                keybinds.map("norg", "n", "gT", "<cmd>Neorg toc<CR>")

                -- For magnify code block, remap to <LocalLeader>cx
                keybinds.map("norg", "n", "<LocalLeader>cx", "<Plug>(neorg.looking-glass.magnify-code-block)")

                -- Open today's daily note quickly (buffer-local)
                keybinds.map("norg", "n", "<LocalLeader>tj", "<cmd>Neorg journal today<CR>")

                -- Toggle concealer icons (for quick plain view)
                keybinds.map("norg", "n", "<LocalLeader>ic", "<cmd>Neorg toggle-concealer<CR>")

                -- Quick search workspace headlines with Telescope
                keybinds.map("norg", "n", "<LocalLeader>sh", "<cmd>Telescope neorg headlines<CR>")

                -- Add keybinds to which-key if it's installed
                if ok then
                  wk.register({
                    t = {
                      name = "+journal",
                      j = "Open today's journal"
                    },
                  }, {
                    prefix = "<localleader>",
                    mode = "n",
                  })
                end
              end,
            },
          },
        },
      })

      -- Define global keymap here, after Neorg setup to avoid errors if Neorg isn't loaded yet
      vim.keymap.set("n", "<LocalLeader>tj", "<cmd>Neorg journal today<CR>", { noremap = true, silent = true })

      -- Register global which-key label for the above mapping if which-key installed
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.register({
          ["<localleader>"] = {
            t = {
              j = "Open today's Neorg journal",
            },
          },
        }, { mode = "n" })
      end
    end,
  },
}

