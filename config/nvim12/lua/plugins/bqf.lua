-- BQF https://github.com/kevinhwang91/nvim-bqf

return {
  src = "https://github.com/kevinhwang91/nvim-bqf",
  name = "nvim-bqf",
  setup = function()
    -- Autocommand to trigger loading when opening a Quickfix window
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function()
        -- Ensure plugin is loaded (if not already)
        vim.cmd("packadd nvim-bqf")
        
        -- Apply configuration
        require("bqf").setup({
          auto_enable = true,
          auto_resize_height = true,
          preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
            show_title = true,
            show_scroll_bar = true,
            wrap = false,
            winblend = 0,
          },
          func_map = {
            open = "<CR>",
            openc = "o",
            drop = "O",
            split = "<C-x>",
            vsplit = "<C-v>",
            tab = "t",
            tabb = "T",
            tabc = "<C-t>",
            prevfile = "<C-p>",
            nextfile = "<C-n>",
            filter = "zn",
            filterr = "zN",
            fzffilter = "zf",
          },
          filter = {
            fzf = {
              action_for = {
                ["ctrl-t"] = "tabedit",
                ["ctrl-v"] = "vsplit",
                ["ctrl-x"] = "split",
                ["ctrl-q"] = "signtoggle",
                ["ctrl-c"] = "closeall",
              },
              extra_opts = { "--bind", "ctrl-o:toggle-all" },
            },
          },
        })
      end,
    })
  end,
}
