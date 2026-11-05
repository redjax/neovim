--
-- [ OPTIONS ]
--
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

-- Disable netrw so nvim-tree handles directory browsing.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
    vim.b[event.buf].cursor_restored = true

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
-- [ PLUGINS ]
--

-- Install missing plugins and make them available to this session.
vim.pack.add({
  -- Tokyo Night colorscheme.
  {
    src = "https://github.com/folke/tokyonight.nvim",
    version = "main",
  },

  -- Kanagawa colorscheme.
  {
    src = "https://github.com/rebelot/kanagawa.nvim",
    version = "master",
  },

  -- Moonfly colorscheme.
  {
    src = "https://github.com/bluz71/vim-moonfly-colors",
    version = "master",
  },

  -- Aura colorscheme.
  {
    src = "https://github.com/daltonmenezes/aura-theme",
    version = "main",
  },

  -- VSCode Modern colorscheme.
  {
    src = "https://github.com/gmr458/vscode_modern_theme.nvim",
    version = "main",
  },

  -- Oxocarbon colorscheme.
  {
    src = "https://github.com/nyoom-engineering/oxocarbon.nvim",
    version = "main",
  },

  -- OneDark Pro colorscheme.
  {
    src = "https://github.com/olimorris/onedarkpro.nvim",
    version = "main",
  },

  -- Eldritch colorscheme.
  {
    src = "https://github.com/eldritch-theme/eldritch.nvim",
    version = "master",
  },

  -- Blink completion, restricted to v1 releases.
  -- The branch-only Renovate manager deliberately skips this version range.
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },

  -- Theme selection and persistence.
  {
    src = "https://github.com/zaldih/themery.nvim",
    version = "main",
  },

  -- Magit-like Git interface.
  {
    src = "https://github.com/NeogitOrg/neogit",
    version = "master",
  },

  -- Default language-server configurations.
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    version = "master",
  },

  -- Language-server installation and management.
  {
    src = "https://github.com/mason-org/mason.nvim",
    version = "main",
  },

  -- Integration between Mason installations and Neovim LSP configurations.
  {
    src = "https://github.com/mason-org/mason-lspconfig.nvim",
    version = "main",
  },

  -- Lua utility dependency used by Telescope and other plugins.
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
    version = "master",
  },

  -- Fuzzy finder, picker, and previewer.
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
    version = "master",
  },

  -- Keybinding hints.
  {
    src = "https://github.com/folke/which-key.nvim",
    version = "main",
  },

  -- Merge conflict resolution.
  {
    src = "https://github.com/spacedentist/resolve.nvim",
  },

  -- Visual hints for learning and discovering Vim motions.
  {
    src = "https://github.com/tris203/precognition.nvim",
    version = "main",
  },

  -- Git change indicators, hunk actions, and blame.
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    version = "main",
  },

  -- Filesystem tree and file-management actions.
  {
    src = "https://github.com/nvim-tree/nvim-tree.lua",
    version = "v1.14.0",
  },

  -- Treesitter parser and syntax infrastructure.
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
  },

  -- Keybinding ergonomics and suggestions.
  {
    src = "https://github.com/tris203/hawtkeys.nvim",
    version = "main",
  },

  -- Mini.nvim is a library with many Lua modules
  {
    src = "https://github.com/nvim-mini/mini.nvim",
    version = "stable",
  },
}, {
  -- Install missing plugins without asking for confirmation.
  confirm = false,
})

--
-- [ THEME / COLORSCHEME ]
--

-- Theme options
-- Load these before any colorscheme.
--

-- Eldritch theme options
require("eldritch").setup({
  styles = {
    comments = {
      italic = false,
    },
    keywords = {
      italic = false,
    },
  },
})

-- Set fallback before Themery restores a saved selection.
vim.cmd.colorscheme("zaibatsu")

-- Provide a menu of installed themes and remember the selected theme.
require("themery").setup({
  themes = {
    {
      name = "Eldritch",
      colorscheme = "eldritch",
    },
    {
      name = "Eldritch Dark",
      colorscheme = "eldritch-dark",
    },
    {
      name = "Eldritch Minimal",
      colorscheme = "eldritch-minimal",
    },
    {
      name = "Kanagawa Wave",
      colorscheme = "kanagawa-wave",
    },
    {
      name = "Kanagawa Dragon",
      colorscheme = "kanagawa-dragon",
    },
    {
      name = "Kanagawa Lotus",
      colorscheme = "kanagawa-lotus",
    },
    {
      name = "Tokyo Night Night",
      colorscheme = "tokyonight-night",
    },
    {
      name = "Tokyo Night Moon",
      colorscheme = "tokyonight-moon",
    },
    {
      name = "Moonfly",
      colorscheme = "moonfly",
    },
    {
      name = "OneDark",
      colorscheme = "onedark",
    },
    {
      name = "OneDark Dark",
      colorscheme = "onedark_dark",
    },
    {
      name = "OneDark Vivid",
      colorscheme = "onedark_vivid",
    },
    {
      name = "Oxocarbon",
      colorscheme = "oxocarbon",
    },
    {
      name = "Slate",
      colorscheme = "slate",
    },
    {
      name = "Vaporwave",
      colorscheme = "vaporwave",
    },
    {
      name = "VSCode Modern",
      colorscheme = "vscode_modern",
    },
    {
      name = "Wild Charm",
      colorscheme = "wildcharm",
    },
    {
      name = "Zaibatsu",
      colorscheme = "zaibatsu",
    },
  },

  -- Preview themes while navigating the menu.
  livePreview = true,
})

-- Open the theme picker with Space+u+t.
vim.keymap.set("n", "<leader>ut", "<cmd>Themery<CR>", {
  desc = "Choose theme",
})

--
-- [ FILE EXPLORER ]
--

local function nvimtree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  -- Register nvim-tree's default mappings.
  api.config.mappings.default_on_attach(bufnr)

  -- Navigate to the parent directory.
  vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))

  -- Display available keybindings.
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
  on_attach = nvimtree_on_attach,

  experimental = {
    session_restore_nvim = false,
  },

  sort = {
    sorter = "case_sensitive",
  },

  view = {
    width = 35,
  },

  renderer = {
    -- Collapse chains of directories with only one subdirectory.
    group_empty = true,

    -- Use simple ASCII indicators instead of Nerd Font icons.
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
        modified = false,
        diagnostics = false,
        bookmarks = false,
      },

      -- Use ASCII characters for directory indicators.
      glyphs = {
        folder = {
          arrow_closed = "+",
          arrow_open = "-",
        },
      },
    },

    -- Visually distinguish directories from files.
    highlight_git = false,
  },

  filters = {
    dotfiles = false,
  },
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
  desc = "Toggle file explorer",
})

--
-- [ COMPLETION ]
--

require("blink.cmp").setup({
  -- Use Blink's built-in default keybindings.
  keymap = {
    preset = "default",
  },

  completion = {
    -- Automatically display documentation for completion items.
    documentation = {
      auto_show = true,
    },
  },

  -- Use the Lua matcher instead of a native binary.
  fuzzy = {
    implementation = "lua",
  },
})

---
--- Neogit
---

-- Initialize Neogit with its default settings and automatic Telescope integration.
require("neogit").setup({})

-- Open the Git status interface in a new tab.
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {
  desc = "Open Neogit",
})

--
-- [ GITSIGNS ]
--

require("gitsigns").setup({
  -- Use ASCII signs without requiring a Nerd Font.
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "?" },
  },

  signs_staged = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "?" },
  },

  -- Keep blame annotations hidden until explicitly enabled.
  current_line_blame = false,

  current_line_blame_opts = {
    -- Wait 750 milliseconds before showing inline blame.
    delay = 750,
  },

  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    -- Register mappings only for buffers attached to Gitsigns.
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        desc = desc,
      })
    end

    -- Navigate Git hunks, preserving native navigation in diff windows.
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, "Next Git hunk")

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, "Previous Git hunk")

    -- Inspect and stage the hunk under the cursor.
    map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Git hunk")
    map("n", "<leader>gs", gitsigns.stage_hunk, "Stage/unstage Git hunk")

    -- Stage only the selected lines.
    map("x", "<leader>gs", function()
      gitsigns.stage_hunk({
        vim.fn.line("."),
        vim.fn.line("v"),
      })
    end, "Stage/unstage selected lines")

    -- Inspect blame without keeping annotations visible.
    map("n", "<leader>gB", function()
      gitsigns.blame_line({ full = true })
    end, "Show line blame")

    -- Toggle inline blame.
    map("n", "<leader>gb", gitsigns.toggle_current_line_blame, "Toggle Git blame")

    -- Compare the current buffer with the Git index.
    map("n", "<leader>gd", gitsigns.diffthis, "Diff against index")

    -- Select a Git hunk as a text object.
    map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Git hunk")
  end,
})

--
-- [ LSP ]
--

-- Initialize Mason using its default settings.
require("mason").setup()

-- Advertise Blink's completion capabilities to all language servers.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Define the language servers to configure, install, and enable.
local servers = {
  -- Lua.
  lua_ls = {
    settings = {
      Lua = {
        -- Recognize Neovim's global vim object.
        diagnostics = {
          globals = { "vim" },
        },

        workspace = {
          -- Avoid prompts about third-party workspace libraries.
          checkThirdParty = false,

          -- Include Neovim's runtime Lua definitions.
          library = { vim.env.VIMRUNTIME },
        },
      },
    },
  },

  -- Go.
  gopls = {},

  -- Bash.
  bashls = {},

  -- PowerShell Editor Services.
  powershell_es = {},

  -- Python completion and analysis.
  pyright = {},

  -- Dockerfiles.
  dockerls = {},

  -- Docker Compose files.
  docker_compose_language_service = {},

  -- YAML and pipeline schema associations.
  yamlls = {
    settings = {
      yaml = {
        -- Validate YAML syntax and applicable schemas.
        validate = true,

        -- Show schema descriptions when hovering.
        hover = true,

        -- Suggest properties and values from applicable schemas.
        completion = true,

        -- Allow the YAML server to format documents.
        format = {
          enable = true,
        },

        -- Use explicit associations instead of automatic catalog matching.
        schemaStore = {
          enable = false,
          url = "",
        },

        -- Accept GitLab CI's !reference sequence tag.
        customTags = { "!reference sequence" },

        -- Associate schemas with project-relative file patterns.
        schemas = {
          -- GitHub Actions workflows.
          ["https://json.schemastore.org/github-workflow.json"] = {
            "/.github/workflows/*.yml",
            "/.github/workflows/*.yaml",
          },

          -- GitHub action metadata at the project root or in subdirectories.
          ["https://json.schemastore.org/github-action.json"] = {
            "/action.yml",
            "/action.yaml",
            "/**/action.yml",
            "/**/action.yaml",
          },

          -- Azure Pipelines and templates in common pipeline directories.
          ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
            "/azure-pipelines.yml",
            "/azure-pipelines.yaml",
            "/azure-pipelines/*.yml",
            "/azure-pipelines/*.yaml",
            "/.azure-pipelines/*.yml",
            "/.azure-pipelines/*.yaml",
          },

          -- GitLab CI configuration and included pipeline fragments.
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
            "/.gitlab-ci.yml",
            "/.gitlab-ci.yaml",
            "/.gitlab/ci/*.yml",
            "/.gitlab/ci/*.yaml",
            "/.gitlab/ci/**/*.yml",
            "/.gitlab/ci/**/*.yaml",
          },
        },
      },
    },
  },

  -- Markdown.
  marksman = {},

  -- TOML.
  taplo = {},
}

-- Configure each server before Mason enables it.
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

-- Install and automatically enable the language servers listed above.
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = vim.tbl_keys(servers),
})

-- Add buffer-local mappings when a language server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- Jump to the definition under the cursor.
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, {
      buffer = event.buf,
      desc = "Go to definition",
    })

    -- Request formatting asynchronously from an attached language server.
    vim.keymap.set("n", "grf", function()
      vim.lsp.buf.format({
        async = true,
      })
    end, {
      buffer = event.buf,
      desc = "Format buffer",
    })
  end,
})

--
-- [ KEYBINDING ERGONOMICS ]
--

require("hawtkeys").setup({
  leader = " ",
  keyboardLayout = "qwerty",
})

--
-- [ SEARCH ]
--

-- Initialize Telescope with its default settings.
require("telescope").setup({})

-- Load Telescope's built-in search pickers.
local pickers = require("telescope.builtin")

-- List available Telescope pickers.
vim.keymap.set("n", "<leader>sp", pickers.builtin, {
  desc = "Search pickers",
})

-- Search open buffers.
vim.keymap.set("n", "<leader>sb", pickers.buffers, {
  desc = "Search buffers",
})

-- Search filenames in the working directory.
vim.keymap.set("n", "<leader>sf", pickers.find_files, {
  desc = "Search files",
})

-- Search for the word under the cursor.
vim.keymap.set("n", "<leader>sw", pickers.grep_string, {
  desc = "Search current word",
})

-- Search file contents interactively.
vim.keymap.set("n", "<leader>sg", pickers.live_grep, {
  desc = "Search by grep",
})

-- Reopen the previous Telescope picker.
vim.keymap.set("n", "<leader>sr", pickers.resume, {
  desc = "Resume search",
})

-- Search Neovim and plugin help tags.
vim.keymap.set("n", "<leader>sh", pickers.help_tags, {
  desc = "Search help",
})

-- Search available system manual pages.
vim.keymap.set("n", "<leader>sm", pickers.man_pages, {
  desc = "Search manuals",
})

--
-- [ MOTION HINTS ]
--

require("precognition").setup({
  -- Display motion hints immediately.
  startVisible = true,

  -- Hide empty virtual hint lines.
  showBlankVirtLine = false,

  -- Match the active colorscheme's comment highlighting.
  highlightColor = {
    link = "Comment",
  },

  -- Hide the dense per-character f/F hints.
  targetedMotionHints = {
    enabled = false,
  },
})

-- Toggle motion hints with Space+u+p.
vim.keymap.set("n", "<leader>up", "<cmd>Precognition toggle<CR>", {
  desc = "Toggle motion hints",
})

-- Show motion hints until the next cursor movement with Space+u+P.
vim.keymap.set("n", "<leader>uP", "<cmd>Precognition peek<CR>", {
  desc = "Peek motion hints",
})

--
-- [ WHICH-KEY ]
--

require("which-key").setup({
  -- Disable decorative mapping icons.
  icons = {
    mappings = false,
  },

  -- Label keybinding prefixes; individual mappings supply their own descriptions.
  spec = {
    { "<leader>g", group = "Git" },
    { "<leader>s", group = "Search" },
    { "<leader>u", group = "UI" },
  },
})

--
-- [ MINI.NVIM MODULES ]
--

-- Better text objects.
require("mini.ai").setup({})

-- Surround manipulation.
require("mini.surround").setup({})

-- Consistent bracket-based navigation.
require("mini.bracketed").setup({})

-- Highlight and remove trailing whitespace.
require("mini.trailspace").setup({})

-- Visualize indentation scope.
require("mini.indentscope").setup({
  draw = {
    delay = 100,
    animation = require("mini.indentscope").gen_animation.none(),
  },
})

-- Better buffer deletion.
require("mini.bufremove").setup({})

-- Text manipulation operators.
require("mini.operators").setup({
  -- Avoid conflicts with Neovim's built-in LSP gr mappings.
  replace = {
    prefix = "gR",
  },
})

-- Move lines and visual selections.
require("mini.move").setup({
  mappings = {
    -- Move selections in all four directions.
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",

    -- Move lines in normal mode.
    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
  },
})

-- Automatically insert matching brackets and quotes.
require("mini.pairs").setup({})

-- Interactive text alignment.
require("mini.align").setup({})

--
-- [ MINI.NVIM KEYBINDINGS ]
--

local wk = require("which-key")

wk.add({
  -- mini.operators
  { "gx", desc = "Exchange text" },
  { "gX", desc = "Replace with register" },
  { "gm", desc = "Multiply text" },
  { "gs", desc = "Sort text" },
  { "g=", desc = "Evaluate text" },

  -- mini.move
  { "<M-h>", desc = "Move selection left", mode = { "n", "v" } },
  { "<M-j>", desc = "Move selection down", mode = { "n", "v" } },
  { "<M-k>", desc = "Move selection up", mode = { "n", "v" } },
  { "<M-l>", desc = "Move selection right", mode = { "n", "v" } },

  -- mini.pairs
  { "(", desc = "Insert matching parentheses", mode = "i" },
  { "[", desc = "Insert matching brackets", mode = "i" },
  { "{", desc = "Insert matching braces", mode = "i" },
  { '"', desc = "Insert matching quotes", mode = "i" },
  { "'", desc = "Insert matching quotes", mode = "i" },
  { "`", desc = "Insert matching backticks", mode = "i" },

  -- mini.align
  { "ga", desc = "Align text" },
  { "gA", desc = "Align text with preview" },
})

--
-- [ PLUGIN UPDATES ]
--

-- Immediately update one plugin to its configured version.
-- Usage: :PluginUpdate nvim-lspconfig
-- This skips confirmation but still respects the plugin's version constraint.
-- No minimum release age is enforced.
vim.api.nvim_create_user_command("PluginUpdate", function(opts)
  vim.pack.update({ opts.args }, {
    force = true,
  })
end, {
  nargs = 1,
  desc = "Update one plugin without confirmation",
})

-- Immediately update all managed plugins to their configured versions.
-- Usage: :PluginsUpdate
-- No minimum release age is enforced.
vim.api.nvim_create_user_command("PluginsUpdate", function()
  vim.pack.update(nil, {
    force = true,
  })
end, {
  desc = "Update all plugins without confirmation",
})

--
-- [ LOCAL CONFIGURATION ]
--
-- Sources an init.local.lua file if it exists in the same path as this init.lua.
-- Use the local file to override configs, i.e. installing additional plugins on
-- a work machine.
--

local local_config = vim.fn.stdpath("config") .. "/init.local.lua"

if vim.fn.filereadable(local_config) == 1 then
  dofile(local_config)
  vim.notify("Loaded init.local.lua", vim.log.levels.INFO)
end
