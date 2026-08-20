-- Floaterm https://github.com/voldikss/vim-floaterm

return {
  src = "https://github.com/voldikss/vim-floaterm",
  name = "vim-floaterm",

  setup = function()
    -- Detect Windows and configure shell
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

    if is_windows then
      local shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
      vim.opt.shell = shell
      vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
      vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
      vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
      vim.opt.shellquote = ""
      vim.opt.shellxquote = ""
      vim.g.floaterm_shell = shell
    else
      vim.opt.shell = "bash"
      vim.g.floaterm_shell = "bash"
    end

    -- Floaterm settings
    vim.g.floaterm_position = "center"
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8

    -- Keybinds (equivalent to old `keys`)
    vim.keymap.set("n", "<leader>ft", "<cmd>FloatermToggle<CR>", { desc = "Toggle Floaterm" })
    vim.keymap.set("n", "<leader>fn", "<cmd>FloatermNew<CR>", { desc = "New Floaterm" })
    vim.keymap.set("n", "<leader>fj", "<cmd>FloatermNext<CR>", { desc = "Next Floaterm" })
    vim.keymap.set("n", "<leader>fk", "<cmd>FloatermPrev<CR>", { desc = "Prev Floaterm" })
    vim.keymap.set("n", "<leader>fx", "<cmd>FloatermKill<CR>", { desc = "Kill Floaterm" })
  end,
}
