--
-- [ PLUGIN AUTOCOMMANDS ]
--

local plugin_group = vim.api.nvim_create_augroup("MinimalPlugins", {
  clear = true,
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

  -- Treesitter parser and syntax infrastructure.
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = vim.fn.has("nvim-0.12") == 1 and "main" or "master",
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

  -- Diagnostics, references, quickfix, and search-result lists.
  {
    src = "https://github.com/folke/trouble.nvim",
  },

  -- Multiline diagnostic messages.
  {
    src = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },

  -- Filesystem tree.
  {
    src = "https://github.com/SidOfc/carbon.nvim",
  },

  -- Discover and open local repositories through Telescope.
  {
    src = "https://github.com/cljoly/telescope-repo.nvim",
  },

  -- Buffer switcher ranked by frequency and recency.
  {
    src = "https://github.com/dzfrias/arena.nvim",
  },

  -- Preview color literals in buffer text.
  {
    src = "https://github.com/catgoose/nvim-colorizer.lua",
  },

  -- Additional colorschemes.
  {
    src = "https://github.com/ChristianChiarulli/nvcode-color-schemes.vim",
  },

  -- Clickable breadcrumbs and symbol navigation.
  {
    src = "https://github.com/Bekaboo/dropbar.nvim",
  },

  -- Clickable file-buffer tabs.
  {
    src = "https://github.com/akinsho/bufferline.nvim",
  },

  -- Highlight references to the symbol under the cursor.
  {
    src = "https://github.com/RRethy/vim-illuminate",
  },

  -- Org documents, agenda, capture, and task management.
  {
    src = "https://github.com/nvim-orgmode/orgmode",
  },
}, {
  -- Install missing plugins without asking for confirmation.
  confirm = false,
})

--
-- [ ICON PROVIDER ]
--

local mini_icons = require("mini.icons")

mini_icons.setup({
  style = "glyph",
})

-- Supply mini.icons to plugins that expect nvim-web-devicons.
mini_icons.mock_nvim_web_devicons()

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
    {
      name = "NVCode",
      colorscheme = "nvcode",
    },
    {
      name = "Nord",
      colorscheme = "nord",
    },
    {
      name = "Aurora",
      colorscheme = "aurora",
    },
    {
      name = "Gruvbox",
      colorscheme = "gruvbox",
    },
    {
      name = "Palenight",
      colorscheme = "palenight",
    },
    {
      name = "Snazzy",
      colorscheme = "snazzy",
    },
    {
      name = "Xoria",
      colorscheme = "xoria",
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
-- [ NVIM-TREE FILE EXPLORER ]
--

-- local function nvimtree_on_attach(bufnr)
--   local api = require("nvim-tree.api")

--   local function opts(desc)
--     return {
--       desc = "nvim-tree: " .. desc,
--       buffer = bufnr,
--       noremap = true,
--       silent = true,
--       nowait = true,
--     }
--   end

--   -- Register nvim-tree's default mappings.
--   api.config.mappings.default_on_attach(bufnr)

--   -- Navigate to the parent directory.
--   vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))

--   -- Display available keybindings.
--   vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
-- end

-- require("nvim-tree").setup({
--   on_attach = nvimtree_on_attach,

--   experimental = {
--     session_restore_nvim = false,
--   },

--   sort = {
--     sorter = "case_sensitive",
--   },

--   view = {
--     width = 35,
--   },

--   renderer = {
--     -- Collapse chains of directories with only one subdirectory.
--     group_empty = true,

--     -- Use simple ASCII indicators instead of Nerd Font icons.
--     icons = {
--       show = {
--         file = false,
--         folder = false,
--         folder_arrow = true,
--         git = false,
--         modified = false,
--         diagnostics = false,
--         bookmarks = false,
--       },

--       -- Use ASCII characters for directory indicators.
--       glyphs = {
--         folder = {
--           arrow_closed = "+",
--           arrow_open = "-",
--         },
--       },
--     },

--     -- Visually distinguish directories from files.
--     highlight_git = false,
--   },

--   filters = {
--     dotfiles = false,
--   },
-- })

-- vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
--   desc = "Toggle file explorer",
-- })

--
-- [ CARBON FILE EXPLORER ]
--

require("carbon").setup({})

-- Toggle the explorer sidebar.
vim.keymap.set("n", "<leader>e", "<cmd>ToggleSidebarCarbon<CR>", {
  desc = "Toggle file explorer",
})

-- Explore in the current window.
vim.keymap.set("n", "<leader>E", "<cmd>Carbon<CR>", {
  desc = "Explore directory in current window",
})

--
-- [ DROPBAR BREADCRUMBS ]
--

vim.opt.mousemoveevent = true

local dropbar_kinds = {}

for _, kind in ipairs(vim.lsp.protocol.SymbolKind) do
  local icon = mini_icons.get("lsp", kind)
  dropbar_kinds[kind] = icon .. " "
end

require("dropbar").setup({
  icons = {
    enable = true,

    kinds = {
      symbols = dropbar_kinds,

      dir_icon = function(path)
        local icon, hl = mini_icons.get("directory", path)
        return icon .. " ", hl
      end,

      file_icon = function(path)
        local icon, hl = mini_icons.get("file", path)
        return icon .. " ", hl
      end,
    },

    ui = {
      bar = {
        separator = " > ",
        extends = "...",
      },
      menu = {
        separator = " ",
        indicator = "> ",
      },
    },
  },
})

vim.keymap.set("n", "<leader>;", function()
  require("dropbar.api").pick()
end, {
  desc = "Navigate breadcrumbs",
})

--
-- [ TROUBLE DIAGNOSTICS ]
--

-- Use mini.icons for LSP symbol kinds.
local trouble_kinds = {}

for _, kind in ipairs(vim.lsp.protocol.SymbolKind) do
  local icon = mini_icons.get("lsp", kind)
  trouble_kinds[kind] = icon .. " "
end

require("trouble").setup({
  focus = true,

  icons = {
    kinds = trouble_kinds,
    folder_closed = "+ ",
    folder_open = "- ",
    indent = {
      top = "| ",
      middle = "|-",
      last = "`-",
      fold_open = "- ",
      fold_closed = "+ ",
      ws = "  ",
    },
  },
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", {
  desc = "Toggle diagnostics list",
})

vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { desc = "Toggle current-buffer diagnostics" }
)

vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", {
  desc = "Toggle quickfix list",
})

vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", {
  desc = "Toggle location list",
})

--
-- [ BLINK COMPLETION ]
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

--
-- [ DIAGNOSTIC LINES ]
--

require("lsp_lines").setup()

-- Avoid displaying each message twice.
-- Show multiline diagnostics only for the cursor's current line.
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    only_current_line = true,
  },
})

vim.keymap.set("n", "<leader>ul", require("lsp_lines").toggle, {
  desc = "Toggle diagnostic lines",
})

--
-- [ ORGMODE ]
--

-- Initialize cross-platform org homedir path
local org_home = vim.env.ORG_HOME

if not org_home or org_home == "" then
  org_home = vim.fs.joinpath(vim.uv.os_homedir(), "org")
end

org_home = vim.fs.normalize(org_home)

-- Create the Org directory if it does not exist.
vim.fn.mkdir(org_home, "p")

-- Helper for Org files
local function org_file(name)
  return vim.fs.joinpath(org_home, name .. ".org")
end

require("orgmode").setup({
  -- Continue recognizing existing Org files.
  org_agenda_files = {
    org_home .. "/**/*.org",
  },

  -- Use the existing inbox as the default notebook.
  org_default_notes_file = org_file("refile"),

  -- Only two task states for now.
  org_todo_keywords = {
    "TODO",
    "|",
    "BLOCKED",
    "DONE",
  },

  -- Avoid extra bookkeeping while learning.
  org_log_done = false,

  -- Open files with their contents visible.
  org_startup_folded = "showeverything",

  -- One optional capture action, one destination.
  org_capture_templates = {
    t = {
      description = "Task",
      template = "* TODO %?",
      target = org_file("refile"),
    },
  },

  mappings = {
    global = {
      org_agenda = { "<leader>oa", desc = "Open agenda" },
      org_capture = { "<leader>oc", desc = "Capture task" },
    },
  },
})

-- Open inbox
vim.keymap.set("n", "<leader>oi", function()
  vim.cmd.edit(vim.fn.fnameescape(org_file("refile")))
end, {
  desc = "Open Org inbox",
})

-- Open notes
vim.keymap.set("n", "<leader>on", function()
  vim.cmd.edit(vim.fn.fnameescape(org_file("notes")))
end, {
  desc = "Open Org notes",
})

-- Open projects
vim.keymap.set("n", "<leader>op", function()
  vim.cmd.edit(vim.fn.fnameescape(org_file("projects")))
end, {
  desc = "Open Org projects",
})

-- Open today's journal entry, creating it if necessary.
vim.keymap.set("n", "<leader>oj", function()
  vim.cmd.edit(vim.fn.fnameescape(org_file("journal")))

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local date = os.date("%Y-%m-%d")
  local heading = "* " .. date .. " " .. os.date("%A")
  local heading_line

  -- Reuse an existing top-level heading for today.
  for i, line in ipairs(lines) do
    if line == "* " .. date or line:sub(1, 13) == "* " .. date .. " " then
      heading_line = i
      break
    end
  end

  if not heading_line then
    -- Create today's heading at the end of the file.
    if #lines == 1 and lines[1] == "" then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        heading,
        "",
      })
      heading_line = 1
    else
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {
        "",
        heading,
        "",
      })
      heading_line = #lines + 2
    end

    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  end

  -- Find the end of today's entry, including any child headings.
  local entry_end = #lines

  for i = heading_line + 1, #lines do
    if lines[i]:match("^%* ") then
      entry_end = i - 1
      break
    end
  end

  -- Continue on a blank line after the entry's existing content.
  local last_content = entry_end

  while last_content > heading_line and lines[last_content]:match("^%s*$") do
    last_content = last_content - 1
  end

  if last_content == entry_end then
    vim.api.nvim_buf_set_lines(bufnr, entry_end, entry_end, false, { "" })
  end

  vim.api.nvim_win_set_cursor(0, { last_content + 1, 0 })
  vim.cmd("normal! zv")
  vim.cmd("startinsert")
end, {
  desc = "Open today's journal entry",
})
---
--- [ NEOGIT ]
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

  -- SQL language server.
  sqls = {},

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
  group = plugin_group,
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
-- [ TREESITTER ]
--

local treesitter_languages = {
  -- Documentation.
  "markdown",
  "markdown_inline",

  -- Go and module/workspace files.
  "go",
  "gomod",
  "gosum",
  "gowork",

  -- Python.
  "python",

  -- Shell scripting.
  "bash",
  "powershell",

  -- Infrastructure as code.
  "bicep",
  "hcl",
  "terraform",

  -- Structured data, configuration, and YAML-based automation.
  "json",
  "json5",
  "toml",
  "yaml",

  -- Containers.
  "dockerfile",

  -- Databases.
  "sql",

  -- Templates.
  "jinja",
  "jinja_inline",
  "gotmpl",
  "helm",
  "html",

  -- Useful if you write AWS CDK applications in TypeScript/JavaScript.
  "typescript",
  "javascript",

  -- Neovim configuration and documentation.
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "query",
}

if vim.fn.has("nvim-0.12") == 1 then
  -- Neovim 0.12+: use the rewritten main-branch API.
  local treesitter = require("nvim-treesitter")

  treesitter.setup({})

  -- Install missing parsers asynchronously.
  treesitter.install(treesitter_languages)

  -- Enable highlighting when a file is opened.
  vim.api.nvim_create_autocmd("FileType", {
    group = plugin_group,
    desc = "Enable Tree-sitter highlighting when a parser is available",
    callback = function(event)
      -- Skip special buffers such as terminals and plugin interfaces.
      if vim.bo[event.buf].buftype ~= "" then
        return
      end

      -- Files without an installed parser retain traditional highlighting.
      pcall(vim.treesitter.start, event.buf)
    end,
  })
else
  -- Neovim 0.11: use the legacy master-branch API.
  require("nvim-treesitter.configs").setup({
    ensure_installed = treesitter_languages,
    sync_install = false,
    auto_install = false,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    -- Preserve your existing indentation behavior.
    indent = {
      enable = false,
    },
  })
end

--
-- [ HAWTKEYS KEYBIND ERGONOMICS ]
--

require("hawtkeys").setup({
  leader = " ",
  keyboardLayout = "qwerty",
})

--
-- [ TELESCOPE SEARCH ]
--

-- Initialize Telescope with its default settings.
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-t>"] = require("trouble.sources.telescope").open,
      },
      n = {
        ["<C-t>"] = require("trouble.sources.telescope").open,
      },
    },
  },
})

require("telescope").load_extension("repo")

-- Load Telescope's built-in search pickers.
local pickers = require("telescope.builtin")

vim.keymap.set("n", "<leader>t", "<cmd>Telescope<CR>", {
  desc = "Open Telescope",
})

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

-- Find repositories using the system's filesystem index.
vim.keymap.set("n", "<leader>sR", function()
  require("telescope").extensions.repo.cached_list()
end, {
  desc = "Search repositories",
})

--
-- [ COLOR PREVIEWS ]
--

require("colorizer").setup({
  user_default_options = {
    -- Avoid highlighting ordinary words such as "red".
    names = false,

    RGB = true,
    RGBA = true,
    RRGGBB = true,
    RRGGBBAA = true,

    rgb_fn = true,
    hsl_fn = true,
    mode = "background",
  },
})

vim.keymap.set("n", "<leader>uc", "<cmd>ColorizerToggle<CR>", {
  desc = "Toggle color previews",
})

--
-- [ SYMBOL REFERENCE HIGHLIGHTING ]
--

require("illuminate").configure({
  delay = 200,
  disable_keymaps = true,

  providers = {
    "lsp",
    "treesitter",
    "regex",
  },

  min_count_to_highlight = 2,

  filetypes_denylist = {
    "dirbuf",
    "dirvish",
    "fugitive",
    "carbon",
    "Trouble",
    "TelescopePrompt",
  },
})

vim.keymap.set("n", "<leader>ui", function()
  require("illuminate").toggle()
end, {
  desc = "Toggle reference highlighting",
})

--
-- [ PRECOGNITION MOTION HINTS ]
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
-- [ ARENA BUFFER SWITCHER ]
--

require("arena").setup({
  max_items = 10,
  devicons = true,
})

vim.keymap.set("n", "<leader>ba", "<cmd>ArenaToggle<CR>", {
  desc = "Open frequently used buffers",
})

--
-- [ WHICH-KEY ]
--

require("which-key").setup({
  -- Disable decorative mapping icons.
  icons = {
    mappings = true,
  },

  -- Label keybinding prefixes; individual mappings supply their own descriptions.
  spec = {
    { "<leader>g", group = "Git" },
    { "<leader>s", group = "Search" },
    { "<leader>u", group = "UI" },
    { "<leader>b", group = "Buffers" },
    { "<leader>x", group = "Diagnostics / lists" },
    { "<leader>o", group = "Org" },
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

-- Useful statusline without another plugin dependency.
require("mini.statusline").setup({
  use_icons = true,
})

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
-- [ BUFFERLINE ]
--

local function close_buffer(bufnr)
  -- Preserve window layouts and do not force-discard unsaved changes.
  require("mini.bufremove").delete(bufnr, false)
end

require("bufferline").setup({
  options = {
    mode = "buffers",

    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,

    buffer_close_icon = "x",
    modified_icon = "+",
    left_trunc_marker = "<",
    right_trunc_marker = ">",

    indicator = {
      style = "none",
    },

    separator_style = { "|", "|" },

    close_command = close_buffer,
    right_mouse_command = false,
    middle_mouse_command = close_buffer,

    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count)
      return "(" .. count .. ")"
    end,

    always_show_bufferline = true,
  },
})

vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", {
  desc = "Next buffer",
})

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", {
  desc = "Previous buffer",
})

vim.keymap.set("n", "<leader>bd", function()
  close_buffer(0)
end, {
  desc = "Close buffer",
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
-- [ MINI.STARTER START SCREEN ]
--

local starter = require("mini.starter")

starter.setup({
  -- Show the start screen when launching Neovim without a target.
  autoopen = true,

  -- Require Enter to execute an item after filtering.
  evaluate_single = false,

  header = function()
    return "Neovim v" .. tostring(vim.version())
  end,

  items = {
    {
      name = "Find files",
      action = function()
        require("telescope.builtin").find_files()
      end,
      section = "Search",
    },
    {
      name = "Grep project",
      action = function()
        require("telescope.builtin").live_grep()
      end,
      section = "Search",
    },
    {
      name = "Repositories",
      action = function()
        require("telescope").extensions.repo.cached_list()
      end,
      section = "Search",
    },
    {
      name = "Buffers",
      action = function()
        require("telescope.builtin").buffers()
      end,
      section = "Search",
    },

    {
      name = "New file",
      action = "enew",
      section = "Actions",
    },
    {
      name = "Explore directory",
      action = "Carbon",
      section = "Actions",
    },
    {
      name = "Git status",
      action = "Neogit",
      section = "Actions",
    },
    {
      name = "Choose theme",
      action = "Themery",
      section = "Actions",
    },
    {
      name = "Quit",
      action = "quit",
      section = "Actions",
    },

    -- Recent files across all directories.
    starter.sections.recent_files(5, false),
  },

  content_hooks = {
    starter.gen_hook.adding_bullet("> "),
    starter.gen_hook.aligning("center", "center"),
  },

  footer = "Type an item prefix, or use Up/Down and Enter. Backspace clears characters.",
})

-- Reopen the start screen with Space+u+s.
vim.keymap.set("n", "<leader>us", function()
  starter.open()
end, {
  desc = "Open start screen",
})
