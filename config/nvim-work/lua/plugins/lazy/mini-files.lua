-- Mini.files https://github.com/nvim-mini/mini.files

return {
  "echasnovski/mini.files",
  version = "*", -- Use the latest stable version
  keys = {
    {
      "<space>e",
      function()
        -- Check if a mini.files window is already open
        local mini_files_open = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "minifiles" then
            mini_files_open = true
            break
          end
        end

        if mini_files_open then
          -- If it's open, close it
          require("mini.files").close()
        else
          -- If it's not open, open it
          require("mini.files").open()
        end
      end,
      desc = "Toggle file explorer (mini.files)"
    },
  },
  config = function()
    -- Setup mini.files with custom mappings
    require("mini.files").setup({
      mappings = {
        -- Go to parent directory with 'L'
        go_in_plus = "L",
      },
    })
  end,
}
