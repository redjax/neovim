-- Which-key keymap legend https://github.com/folke/which-key.nvim
return {
  src = "https://github.com/folke/which-key.nvim",
  name = "which-key.nvim",
  setup = function()
    local wk = require("which-key")

    wk.setup({
      -- Options:
      --   - left aligned: classic (default)
      --   - right aligned: helix
      --   - center aligned: modern
      preset = "helix",
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,
      filter = function(_)
        return true
      end,
      spec = {},
      notify = true,

      -- Define a trigger.
      --   Only use 1 `triggers = {...}` line below, keep the other commented.
      --   Also comment the `defer = function()` line beneath the disabled triggers.

      -- Disable popup, requires `:WhichKey` to open
      -- triggers = {},
      -- -- Function for trigger above
      -- defer = function()
      --   return true
      -- end,

      -- Open when a key/sequence is pressed that WhichKey recognizes
      triggers = {{
        "<auto>",
        mode = "nxso"
      }, {
        "<leader>",
        mode = "n"
      }, {
        "g",
        mode = "n"
      }},
      -- Function for trigger above
      defer = function(ctx)
        return ctx.mode == "V" or ctx.mode == "<C-V>"
      end,

      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true
        }
      },
      win = {
        no_overlap = true,
        width = 45,
        height = {
          min = 4,
          max = 16
        },
        border = "rounded",
        padding = {0, 1},
        title = false,
        zindex = 1000
      },
      layout = {
        width = {
          min = 20
        },
        spacing = 1
      },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>"
      },
      sort = {"local", "order", "group", "alphanum", "mod"},
      expand = 0,
      replace = {
        key = {function(key)
          return require("which-key.view").format(key)
        end},
        desc = {{"<Plug>%(?(.*)%)?", "%1"}, {"^%+", ""}, {"<[cC]md>", ""}, {"<[cC][rR]>", ""}, {"<[sS]ilent>", ""},
                {"^lua%s+", ""}, {"^call%s+", ""}, {"^:%s*", ""}}
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        ellipsis = "…",
        mappings = true,
        rules = {},
        colors = true,
        keys = {
          Up = " ",
          Down = " ",
          Left = " ",
          Right = " ",
          C = "󰘴 ",
          M = "󰘵 ",
          D = "󰘳 ",
          S = "󰘶 ",
          CR = "󰌑 ",
          Esc = "󱊷 ",
          ScrollWheelDown = "󱕐 ",
          ScrollWheelUp = "󱕑 ",
          NL = "󰌑 ",
          BS = "󰁮",
          Space = "󱁐 ",
          Tab = "󰌒 ",
          F1 = "F1",
          F2 = "F2",
          F3 = "F3",
          F4 = "F4",
          F5 = "F5",
          F6 = "F6",
          F7 = "F7",
          F8 = "F8",
          F9 = "F9",
          F10 = "F10",
          F11 = "F11",
          F12 = "F12"
        }
      },
      show_help = true,
      show_keys = true,
      disable = {
        ft = {},
        bt = {}
      },
      debug = false
    })

    vim.keymap.set("n", "<leader>?", function()
      wk.show({
        global = false
      })
    end, {
      desc = "Buffer Local Keymaps (which-key)"
    })
  end
}
