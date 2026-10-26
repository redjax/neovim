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
  nbsp = "␣"
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
  vim.opt.fileformats = {"dos", "unix"}
end

-- Enable syntax highlighting
vim.cmd('syntax enable')

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
      [vim.diagnostic.severity.HINT] = "H"
    }
  },

  -- Display diagnostic messages alongside buffer text.
  virtual_text = true
})

--
-- [ KEYBINDS ]
--

-- Clear search highlights with Escape.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  desc = "Clear search highlights"
})

-- Save the current buffer with Space+w.
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", {
  desc = "Save file"
})

-- Yank to the system clipboard in normal or visual mode.
vim.keymap.set({"n", "x"}, "gy", '"+y', {
  desc = "Copy to clipboard"
})

-- Paste from the system clipboard.
vim.keymap.set({"n", "x"}, "gp", '"+p', {
  desc = "Paste from clipboard"
})

-- Delete characters or selected text without changing yank registers.
vim.keymap.set({"n", "x"}, "x", '"_x', {
  desc = "Delete character without yank"
})

-- Delete the entire current line without changing yank registers.
vim.keymap.set("n", "X", '"_dd', {
  desc = "Delete line without yank"
})

-- Delete the visual selection without changing yank registers.
vim.keymap.set("x", "X", '"_d', {
  desc = "Delete selection without yank"
})

-- Select the entire buffer without adding jump-list entries.
vim.keymap.set("n", "<leader>a", "<cmd>keepjumps normal! ggVG<CR>", {
  desc = "Select all"
})

-- Move to the first nonblank character in normal mode.
vim.keymap.set("n", "<Home>", "^", {
  desc = "Go to first non-blank character"
})

-- Move to the end of the line in normal mode.
vim.keymap.set("n", "<End>", "$", {
  desc = "Go to end of line"
})

-- Move to the first nonblank character while remaining in insert mode.
vim.keymap.set("i", "<Home>", "<C-o>^", {
  desc = "Insert: go to first non-blank character"
})

-- Move to the end of the line while remaining in insert mode.
vim.keymap.set("i", "<End>", "<C-o>$", {
  desc = "Insert: go to end of line"
})

-- Map 'z' to fold (close) the current fold
vim.keymap.set('n', 'z', 'zc', {
  noremap = true,
  desc = "Fold section under cursor"
})

-- Map 'zz' to unfold (open) the current fold
vim.keymap.set('n', 'zz', 'zo', {
  noremap = true,
  desc = "Unfold section under cursor"
})

--
-- [ AUTOCOMMANDS ]
--
-- Clear previously registered autocommands if this configuration is sourced again.
local config_group = vim.api.nvim_create_augroup("MinimalConfig", {
  clear = true
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
  end
})

--
-- [ PLUGINS ]
--

-- Install missing plugins and make them available to this session.
vim.pack.add({"https://github.com/folke/tokyonight.nvim", -- Tokyo Night colorscheme.
"https://github.com/rebelot/kanagawa.nvim", -- Kanagawa colorscheme with Wave, Dragon, and Lotus variants.
"https://github.com/zaldih/themery.nvim", -- Colorscheme picker with live preview and persistent selection.
{
  src = "https://github.com/saghen/blink.cmp", -- Blink completion, restricted to stable v1 releases.
  version = vim.version.range("1.*")
}, -- Default language-server configurations.
"https://github.com/neovim/nvim-lspconfig", -- Language-server installation and management.
"https://github.com/mason-org/mason.nvim", -- Integration between Mason installations and Neovim LSP configurations.
"https://github.com/mason-org/mason-lspconfig.nvim", -- Telescope's Lua utility dependency.
"https://github.com/nvim-lua/plenary.nvim", -- Searchable lists of files, buffers, help, and more.
"https://github.com/nvim-telescope/telescope.nvim", -- Keybinding hints.
"https://github.com/folke/which-key.nvim"}, {
  -- Install missing plugins without asking for confirmation.
  confirm = false
})

--
-- [ THEME / COLORSCHEME ]
--

-- Use Kanagawa Wave as the fallback before Themery restores a saved selection.
vim.cmd.colorscheme("kanagawa-wave")

-- Provide a menu of installed themes and remember the selected theme.
require("themery").setup({
  themes = {{
    name = "Kanagawa Wave",
    colorscheme = "kanagawa-wave"
  }, {
    name = "Kanagawa Dragon",
    colorscheme = "kanagawa-dragon"
  }, {
    name = "Kanagawa Lotus",
    colorscheme = "kanagawa-lotus"
  }, {
    name = "Tokyo Night Night",
    colorscheme = "tokyonight-night"
  }, {
    name = "Tokyo Night Moon",
    colorscheme = "tokyonight-moon"
  }},

  -- Preview themes while navigating the menu.
  livePreview = true
})

-- Open the theme picker with Space+u+t.
vim.keymap.set("n", "<leader>ut", "<cmd>Themery<CR>", {
  desc = "Choose theme"
})

--
-- [ COMPLETION ]
--

require("blink.cmp").setup({
  -- Use Blink's built-in default keybindings.
  keymap = {
    preset = "default"
  },

  completion = {
    -- Automatically display documentation for completion items.
    documentation = {
      auto_show = true
    }
  },

  -- Use the Lua matcher instead of a native binary.
  fuzzy = {
    implementation = "lua"
  }
})

--
-- [ LSP ]
--

-- Initialize Mason using its default settings.
require("mason").setup()

-- Advertise Blink's completion capabilities to all language servers.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities()
})

-- Define the language servers to configure, install, and enable.
local servers = {
  -- Lua.
  lua_ls = {
    settings = {
      Lua = {
        -- Recognize Neovim's global vim object.
        diagnostics = {
          globals = {"vim"}
        },

        workspace = {
          -- Avoid prompts about third-party workspace libraries.
          checkThirdParty = false,

          -- Include Neovim's runtime Lua definitions.
          library = {vim.env.VIMRUNTIME}
        }
      }
    }
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
          enable = true
        },

        -- Use explicit associations instead of automatic catalog matching.
        schemaStore = {
          enable = false,
          url = ""
        },

        -- Accept GitLab CI's !reference sequence tag.
        customTags = {"!reference sequence"},

        -- Associate schemas with project-relative file patterns.
        schemas = {
          -- GitHub Actions workflows.
          ["https://json.schemastore.org/github-workflow.json"] = {"/.github/workflows/*.yml",
                                                                   "/.github/workflows/*.yaml"},

          -- GitHub action metadata at the project root or in subdirectories.
          ["https://json.schemastore.org/github-action.json"] = {"/action.yml", "/action.yaml", "/**/action.yml",
                                                                 "/**/action.yaml"},

          -- Azure Pipelines and templates in common pipeline directories.
          ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {"/azure-pipelines.yml",
                                                                                                               "/azure-pipelines.yaml",
                                                                                                               "/azure-pipelines/*.yml",
                                                                                                               "/azure-pipelines/*.yaml",
                                                                                                               "/.azure-pipelines/*.yml",
                                                                                                               "/.azure-pipelines/*.yaml"},

          -- GitLab CI configuration and included pipeline fragments.
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {"/.gitlab-ci.yml",
                                                                                                                "/.gitlab-ci.yaml",
                                                                                                                "/.gitlab/ci/*.yml",
                                                                                                                "/.gitlab/ci/*.yaml",
                                                                                                                "/.gitlab/ci/**/*.yml",
                                                                                                                "/.gitlab/ci/**/*.yaml"}
        }
      }
    }
  },

  -- Markdown.
  marksman = {},

  -- TOML.
  taplo = {}
}

-- Configure each server before Mason enables it.
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

-- Install and automatically enable the language servers listed above.
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = vim.tbl_keys(servers)
})

-- Add buffer-local mappings when a language server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- Jump to the definition under the cursor.
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, {
      buffer = event.buf,
      desc = "Go to definition"
    })

    -- Request formatting asynchronously from an attached language server.
    vim.keymap.set("n", "grf", function()
      vim.lsp.buf.format({
        async = true
      })
    end, {
      buffer = event.buf,
      desc = "Format buffer"
    })
  end
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
  desc = "Search pickers"
})

-- Search open buffers.
vim.keymap.set("n", "<leader>sb", pickers.buffers, {
  desc = "Search buffers"
})

-- Search filenames in the working directory.
vim.keymap.set("n", "<leader>sf", pickers.find_files, {
  desc = "Search files"
})

-- Search for the word under the cursor.
vim.keymap.set("n", "<leader>sw", pickers.grep_string, {
  desc = "Search current word"
})

-- Search file contents interactively.
vim.keymap.set("n", "<leader>sg", pickers.live_grep, {
  desc = "Search by grep"
})

-- Reopen the previous Telescope picker.
vim.keymap.set("n", "<leader>sr", pickers.resume, {
  desc = "Resume search"
})

-- Search Neovim and plugin help tags.
vim.keymap.set("n", "<leader>sh", pickers.help_tags, {
  desc = "Search help"
})

-- Search available system manual pages.
vim.keymap.set("n", "<leader>sm", pickers.man_pages, {
  desc = "Search manuals"
})

--
-- [ WHICH-KEY ]
--

require("which-key").setup({
  -- Disable decorative mapping icons.
  icons = {
    mappings = false
  },

  -- Label the Space+s prefix as Search.
  spec = {{
    "<leader>s",
    group = "Search"
  }},
  {
    "<leader>u",
    group = "UI"
  }
})

--
-- [ PLUGIN UPDATES ]
--

-- Immediately update one plugin, bypassing any custom cooldown logic.
-- Usage: :PluginUpdate nvim-lspconfig
-- This still respects the plugin's configured version constraint.
vim.api.nvim_create_user_command("PluginUpdate", function(opts)
  vim.pack.update({opts.args}, {
    force = true
  })
end, {
  nargs = 1,
  desc = "Immediately update one plugin without confirmation"
})

-- Check for available updates once per day.
local update_check_interval = 24 * 60 * 60

-- Only install candidate versions that have aged for at least seven days.
-- To manually install a single plugin, even if it's not old enough, run:
--   :lua vim.pack.update({ "<plugin-name>" }, { force = true })
local minimum_update_age = 7 * 24 * 60 * 60

-- Store the last attempt timestamp outside the configuration repository.
local update_stamp = vim.fn.stdpath("state") .. "/plugin-update-check"

-- Prevent overlapping update calls within this Neovim instance.
local update_running = false

-- Share the update operation between automatic and manual updates.
local function update_plugins()
  if update_running then
    return
  end

  update_running = true

  -- Ensure the state directory exists before writing the timestamp.
  vim.fn.mkdir(vim.fn.stdpath("state"), "p")

  -- Record the attempt first to avoid retrying on every startup after a failure.
  vim.fn.writefile({tostring(os.time())}, update_stamp)

  -- Apply updates without opening the confirmation buffer.
  local ok, err = pcall(vim.pack.update, nil, {
    force = true
  })

  update_running = false

  -- Report errors without opening an update-review tab.
  if not ok then
    vim.notify("Plugin update failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- Allow immediate manual updates regardless of the seven-day interval.
vim.api.nvim_create_user_command("PluginsUpdate", update_plugins, {
  desc = "Update plugins now without confirmation"
})

-- Schedule one automatic update check after startup.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    -- Skip automatic updates in headless sessions.
    if #vim.api.nvim_list_uis() == 0 then
      return
    end

    -- Wait five seconds after startup before checking the interval.
    vim.defer_fn(function()
      -- Use the timestamp file's modification time as the last attempt time.
      local last_check = vim.fn.getftime(update_stamp)

      -- On first launch, start the interval without immediately updating.
      if last_check == -1 then
        vim.fn.mkdir(vim.fn.stdpath("state"), "p")
        vim.fn.writefile({tostring(os.time())}, update_stamp)
        return
      end

      -- Update only when at least seven days have elapsed.
      if os.time() - last_check >= update_interval then
        update_plugins()
      end
    end, 5000)
  end
})
