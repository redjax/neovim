-- Neorg (neo org-mode) https://github.com/vhyrro/luarocks.nvim

return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Loads before other plugins
    config = true,   -- Runs require("luarocks-nvim").setup()
  },
  {
    enabled = true,
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
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
              workspaces = { notes = "~/notes" },
              default_workspace = "notes",
            },
          },
        },
      })
    end,
  },
}

