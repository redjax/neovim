# NvChad <!-- omit in toc -->

My [NvChad configuration](https://nvchad.com).

## Table of Contents <!-- omit in toc -->

- [Configuration](#configuration)
  - [Theme](#theme)
- [Cheatsheet](#cheatsheet)
  - [General](#general)
  - [File Navigation](#file-navigation)
  - [Buffers \& Tabs](#buffers--tabs)
  - [Window Management](#window-management)
  - [LSP](#lsp)
  - [Telescope](#telescope)
  - [Nvim Tree](#nvim-tree)
  - [Git](#git)
  - [Terminal](#terminal)
  - [Comments](#comments)
  - [Cheatsheet Command](#cheatsheet-command)
- [Links](#links)

## Configuration

### Theme

NvChad has a built-in theme switcher, which you can open with `<leader>th` (default: `<Space>th`). When you select a new theme, NvChad edits the [`chadrc.lua` file](./lua/chadrc.lua) and sets the `theme` variable to your selection.

> [!NOTE]
> Each time the theme changes, you have to commit the `chadrc.lua` changes to git and push them, then merge to main. This is a bit more cumbersome than my other configs, which all use [Themery](https://github.com/zaldih/themery.nvim), but NvChad compiles the base64 themes to bytecode, which is incompatible with the `dofile(vim.g.base46_cache .. "defaults")` operation that Themery uses to change the theme.

## Cheatsheet

> [!NOTE]
> `<leader>` is `<Space>` by default.

### General

| Keybind | Action |
|---------|--------|
| `<leader>ch` | Open NvChad cheatsheet (searchable) |
| `<leader>th` | Theme switcher (live preview + persist) |
| `<Esc>` | Clear search highlights |
| `<leader>n` | Toggle line numbers |
| `<leader>rn` | Toggle relative line numbers |
| `<C-s>` | Save file |
| `<C-c>` | Copy whole file to system clipboard |

### File Navigation

| Keybind | Action |
|---------|--------|
| `<leader>ff` | Find files |
| `<leader>fo` | Find recent/old files |
| `<leader>fw` | Live grep (search text in files) |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find help tags |
| `<leader>fa` | Find all files (includes hidden) |
| `<leader>fz` | Find in current buffer (fuzzy) |
| `<leader>cm` | Git commits |
| `<leader>gt` | Git status |
| `<leader>ma` | Find marks |

### Buffers & Tabs

| Keybind | Action |
|---------|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>x` | Close buffer |
| `<leader>b` | New buffer |

### Window Management

| Keybind | Action |
|---------|--------|
| `<C-h>` | Move to left window |
| `<C-j>` | Move to bottom window |
| `<C-k>` | Move to top window |
| `<C-l>` | Move to right window |

### LSP

| Keybind | Action |
|---------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `gi` | Go to implementation |
| `<leader>D` | Go to type definition |
| `<leader>ra` | Rename symbol (NvRenamer) |
| `<leader>ca` | Code action |
| `gr` | Show references |
| `<leader>ds` | Diagnostic: show float |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>q` | Diagnostic: set loclist |
| `<leader>wa` | Add workspace folder |
| `<leader>wr` | Remove workspace folder |
| `<leader>wl` | List workspace folders |
| `<leader>fm` | Format file |

### Telescope

| Keybind | Action |
|---------|--------|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fo` | Old/recent files |
| `<leader>fa` | Find all (hidden files too) |
| `<leader>fz` | Fuzzy find in current buffer |
| `<leader>pt` | Pick hidden terminal |

### Nvim Tree

| Keybind | Action |
|---------|--------|
| `<C-n>` | Toggle file tree |
| `<leader>e` | Focus file tree |
| **Inside tree:** | |
| `a` | Create file/directory |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `p` | Paste |
| `x` | Cut |
| `y` | Copy name |
| `Y` | Copy relative path |
| `gy` | Copy absolute path |
| `o` | Open with system app |
| `<CR>` or `l` | Open file |
| `h` | Close directory |
| `v` | Vertical split open |
| `H` | Toggle hidden/dotfiles |

### Git

| Keybind | Action |
|---------|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>rh` | Reset hunk |
| `<leader>ph` | Preview hunk |
| `<leader>gb` | Git blame (line) |
| `<leader>td` | Toggle deleted (show/hide) |

### Terminal

| Keybind | Action |
|---------|--------|
| `<leader>h` | Open horizontal terminal |
| `<leader>v` | Open vertical terminal |
| `<A-h>` | Toggle horizontal terminal |
| `<A-v>` | Toggle vertical terminal |
| `<A-i>` | Toggle floating terminal |

### Comments

| Keybind | Mode | Action |
|---------|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual | Toggle line comment (selection) |
| `gb` | Visual | Toggle block comment (selection) |

### Cheatsheet Command

| Command | Action |
|---------|--------|
| `:NvCheatsheet` | Open the built-in cheatsheet |
| `:NvChadThemes` | Open theme picker |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/tool installer |
| `:LspInfo` | Show active LSP clients |
| `:Lint` | Trigger linting manually |
| `:ConformInfo` | Show active formatters |

## Links

- [NvChad home](https://nvchad.com)
- [NvChad docs](https://nvchad.com/docs/quickstart/install)
- [NvChad Github](https://github.com/NvChad/NvChad)
- [NvChad wiki](https://github.com/NvChad/NvChad/wiki)
