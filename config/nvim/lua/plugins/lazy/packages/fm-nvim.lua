-- fm-nvim https://github.com/is0n/fm-nvim

return {
    lazy = false,
    "is0n/fm-nvim",
    config = function()
      require("fm-nvim").setup({
        -- Command used to open files
        edit_cmd = "edit",
        -- You can run functions on open/close if you want
        on_close = {},
        on_open = {},
        -- UI Options
        ui = {
          default = "float", -- or "split"
          float = {
            border = "rounded",
            float_hl = "Normal",
            border_hl = "FloatBorder",
            blend = 0,
            height = 0.8,
            width = 0.8,
            x = 0.5,
            y = 0.5,
          },
          split = {
            direction = "topleft",
            size = 24,
          },
        },
        -- Terminal commands for file managers (must be in your $PATH)
        cmds = {
          lf_cmd = "lf",
          ranger_cmd = "ranger",
          nnn_cmd = "nnn",
          vifm_cmd = "vifm",
          xplr_cmd = "xplr",
          fff_cmd = "fff",
          twf_cmd = "twf",
          fzf_cmd = "fzf",
          fzy_cmd = "find . | fzy",
          skim_cmd = "sk",
          broot_cmd = "broot",
          gitui_cmd = "gitui",
          joshuto_cmd = "joshuto",
          lazygit_cmd = "lazygit",
          neomutt_cmd = "neomutt",
          taskwarrior_cmd = "taskwarrior-tui",
        },
        -- Key mappings inside the floating/split window
        mappings = {
          vert_split = "<C-v>",
          horz_split = "<C-h>",
          tabedit = "<C-t>",
          edit = "<C-e>",
          ESC = "<ESC>",
        },
        -- Path to broot config (optional)
        broot_conf = vim.fn.stdpath("data") .. "/site/pack/packer/start/fm-nvim/assets/broot_conf.hjson",
      })
  
      -- Example keymap: Open LF (change to your preferred file manager if desired)
      vim.keymap.set("n", "<leader>lf", "<Cmd>Lf<CR>", { desc = "Open LF file manager" })
      vim.keymap.set("n", "<leader>ra", "<Cmd>Ranger<CR>", { desc = "Open Ranger file manager" })
      -- Add more keymaps for other file managers as you wish!
    end,
}
  