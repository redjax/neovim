--
-- [ OPTIONS ]
--

-- Use env var NVIM_DISABLE_PLUGINS=1 to disable plugin loading
local plugins_enabled = vim.env.NVIM_DISABLE_PLUGINS ~= "1"

-- Use Space as the global leader key.
vim.g.mapleader = " "

-- Use backslash as the buffer-local leader key.
vim.g.maplocalleader = "\\"

-- Enable 24-bit colors.
vim.opt.termguicolors = true

-- Display absolute line numbers.
vim.opt.number = true

-- Enable mouse support in all modes.
vim.opt.mouse = "a"

-- Use the system clipboard for the unnamed register.
vim.opt.clipboard = "unnamedplus"

-- Disable swap files; unsaved changes will not have swap-based crash recovery.
vim.opt.swapfile = false

-- Do not retain backup files after successful writes.
vim.opt.backup = false

-- Preserve undo history between sessions using Neovim's default undo directory.
vim.opt.undofile = true

-- Trigger CursorHold events after 250 milliseconds without typing.
vim.opt.updatetime = 250

-- Always reserve space for diagnostic and other signs.
vim.opt.signcolumn = "yes"

-- Display otherwise invisible whitespace characters.
vim.opt.list = true

-- Choose the symbols used to display whitespace.
vim.opt.listchars = {
  -- Display tabs with an arrow followed by spaces.
  tab = "» ",

  -- Display trailing spaces as middle dots.
  trail = "·",

  -- Display nonbreaking spaces with a visible symbol.
  nbsp = "␣",
}

-- Keep eight lines visible above and below the cursor when possible.
vim.opt.scrolloff = 8

-- Keep eight columns visible beside the cursor when scrolling horizontally.
-- Only applies when line wrapping is disabled.
vim.opt.sidescrolloff = 8

-- Open vertical splits to the right of the current window instead of the left.
vim.opt.splitright = true

-- Open horizontal splits below the current window instead of above.
vim.opt.splitbelow = true

-- Preview substitutions in a separate window.
vim.opt.inccommand = "split"

-- Highlight the line containing the cursor.
vim.opt.cursorline = true

-- Search options
vim.opt.ignorecase = true -- ignore case in search patterns unless overridden
vim.opt.smartcase = true -- make searches case-sensitive when the pattern contains an uppercase letter
vim.opt.incsearch = true -- show matching text as you type
vim.opt.hlsearch = true -- highlight matches

-- Preserve indentation on visually wrapped lines.
vim.opt.breakindent = true

-- Visually wrap long lines without inserting line breaks.
vim.opt.wrap = true

-- Display a tab character as two columns.
vim.opt.tabstop = 2

-- Make Tab and Backspace use two-column soft tab stops in insert mode.
vim.o.softtabstop = 2

-- Use two columns for indentation operations.
vim.opt.shiftwidth = 2

-- Insert spaces instead of tab characters.
vim.opt.expandtab = true

-- Automatically adjust indentation for new lines using basic C-like syntax rules.
vim.opt.smartindent = true

-- Set the target width for formatting and automatic text wrapping.
vim.opt.textwidth = 80

-- File encoding
if vim.g.platform == "windows" then
  vim.opt.fileformats = { "dos", "unix" }
end

-- Disable netrw only when the managed plugin configuration is enabled.
if plugins_enabled then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Use PowerShell 7 on Windows when it is available; otherwise keep the default shell.
if vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 then
  vim.opt.shell = "pwsh"

  -- Run commands without the startup banner or user profile.
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -Command"

  -- Do not wrap PowerShell commands in cmd.exe-style outer quotes.
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""

  -- Capture standard output and errors as UTF-8 for commands such as :make.
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

  -- Redirect shell-command output to a UTF-8 file.
  vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
end

-- Configure how language-server diagnostics are displayed.
vim.diagnostic.config({
  signs = {
    -- Use ASCII signs without requiring a Nerd Font.
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },

  -- Display diagnostic messages alongside buffer text.
  virtual_text = true,
})

--
-- [ KEYBINDS ]
--

-- Clear search highlights with Escape.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  desc = "Clear search highlights",
})

-- Save the current buffer with Space+w.
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", {
  desc = "Save file",
})

-- Yank to the system clipboard in normal or visual mode.
vim.keymap.set({ "n", "x" }, "gy", '"+y', {
  desc = "Copy to clipboard",
})

-- Paste from the system clipboard.
vim.keymap.set({ "n", "x" }, "gp", '"+p', {
  desc = "Paste from clipboard",
})

-- Delete characters or selected text without changing yank registers.
vim.keymap.set({ "n", "x" }, "x", '"_x', {
  desc = "Delete character without yank",
})

-- Delete the entire current line without changing yank registers.
vim.keymap.set("n", "X", '"_dd', {
  desc = "Delete line without yank",
})

-- Delete the visual selection without changing yank registers.
vim.keymap.set("x", "X", '"_d', {
  desc = "Delete selection without yank",
})

-- Select the entire buffer without adding jump-list entries.
vim.keymap.set("n", "<leader>a", "<cmd>keepjumps normal! ggVG<CR>", {
  desc = "Select all",
})

-- Move to the first nonblank character in normal mode.
vim.keymap.set("n", "<Home>", "^", {
  desc = "Go to first non-blank character",
})

-- Move to the end of the line in normal mode.
vim.keymap.set("n", "<End>", "$", {
  desc = "Go to end of line",
})

-- Move to the first nonblank character while remaining in insert mode.
vim.keymap.set("i", "<Home>", "<C-o>^", {
  desc = "Insert: go to first non-blank character",
})

-- Move to the end of the line while remaining in insert mode.
vim.keymap.set("i", "<End>", "<C-o>$", {
  desc = "Insert: go to end of line",
})

-- Map 'z' to fold (close) the current fold
vim.keymap.set("n", "z", "zc", {
  noremap = true,
  desc = "Fold section under cursor",
})

-- Map 'zz' to unfold (open) the current fold
vim.keymap.set("n", "zz", "zo", {
  noremap = true,
  desc = "Unfold section under cursor",
})

-- Navigate between windows using Ctrl+h/j/k/l.
vim.keymap.set("n", "<C-h>", "<C-w>h", {
  desc = "Move to left window",
})

vim.keymap.set("n", "<C-j>", "<C-w>j", {
  desc = "Move to lower window",
})

vim.keymap.set("n", "<C-k>", "<C-w>k", {
  desc = "Move to upper window",
})

vim.keymap.set("n", "<C-l>", "<C-w>l", {
  desc = "Move to right window",
})

--
-- [ AUTOCOMMANDS ]
--
-- Clear previously registered autocommands if this configuration is sourced again.
local config_group = vim.api.nvim_create_augroup("MinimalConfig", {
  clear = true,
})

-- Restore the last cursor position when a file is first displayed.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = config_group,
  desc = "Restore the last cursor position",
  callback = function(event)
    -- Skip special buffers and buffers already handled during this session.
    if vim.bo[event.buf].buftype ~= "" or vim.b[event.buf].cursor_restored then
      return
    end

    -- Leave Git commit messages and interactive rebases at their initial position.
    local filetype = vim.bo[event.buf].filetype
    if filetype == "gitcommit" or filetype == "gitrebase" then
      return
    end

    -- Restore only once per buffer, not every time its window is entered.
    vim.api.nvim_buf_set_var(event.buf, "cursor_restored", true)

    -- The double-quote mark records the cursor position from the previous edit.
    local position = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)

    -- Ignore missing marks and positions beyond the current end of the file.
    if position[1] < 1 or position[1] > line_count then
      return
    end

    -- Clamp the saved byte column if the line has become shorter.
    local line = vim.api.nvim_buf_get_lines(event.buf, position[1] - 1, position[1], false)[1]
    position[2] = math.min(position[2], #line)

    -- Restore the cursor directly instead of injecting keystrokes.
    vim.api.nvim_win_set_cursor(0, position)

    -- Open any folds hiding the restored cursor position.
    vim.cmd("normal! zv")
  end,
})

-- Create missing parent directories before writing a local file.
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
  group = config_group,
  desc = "Create missing parent directories before writing",
  callback = function(event)
    -- Use the write target, which may differ from the current buffer's name.
    local file = event.match

    -- Ignore unnamed targets and URI-style paths handled by other plugins.
    -- Requiring at least two scheme characters avoids matching Windows drives.
    if file == "" or file:match("^%a[%w+.-]+:") then
      return
    end

    -- Create the parent directory and any missing intermediate directories.
    local directory = vim.fn.fnamemodify(file, ":p:h")
    vim.fn.mkdir(directory, "p")
  end,
})

--
-- [ PLUGIN CONFIGURATION ]
--

-- Load plugins.lua if plugin loading is not disabled
if plugins_enabled then
  dofile(vim.fn.stdpath("config") .. "/plugins.lua")
end

--
-- [ LOCAL CONFIGURATION ]
--
-- !! NO EDITS BELOW THIS SECTION !!
--
-- Sources an init.local.lua file if it exists in the same path as this init.lua.
-- Use the local file to override configs, i.e. installing additional plugins on
-- a work machine. It should be the last thing neovim loads to allow overriding
-- all configurations defined here.
--

local local_config = vim.fn.stdpath("config") .. "/init.local.lua"

if vim.fn.filereadable(local_config) == 1 then
  dofile(local_config)
  vim.notify("Loaded init.local.lua", vim.log.levels.INFO)
end
