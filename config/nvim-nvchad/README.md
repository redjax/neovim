# NvChad <!-- omit in toc -->

My [NvChad configuration](https://nvchad.com).

## Table of Contents <!-- omit in toc -->

- [Configuration](#configuration)
  - [Theme](#theme)
- [Links](#links)

## Configuration

### Theme

NvChad has a built-in theme switcher, which you can open with `<leader>th` (default: `<Space>th`). When you select a new theme, NvChad edits the [`chadrc.lua` file](./lua/chadrc.lua) and sets the `theme` variable to your selection.

> [!NOTE]
> Each time the theme changes, you have to commit the `chadrc.lua` changes to git and push them, then merge to main. This is a bit more cumbersome than my other configs, which all use [Themery](https://github.com/zaldih/themery.nvim), but NvChad compiles the base64 themes to bytecode, which is incompatible with the `dofile(vim.g.base46_cache .. "defaults")` operation that Themery uses to change the theme.

## Links

- [NvChad home](https://nvchad.com)
- [NvChad docs](https://nvchad.com/docs/quickstart/install)
- [NvChad Github](https://github.com/NvChad/NvChad)
- [NvChad wiki](https://github.com/NvChad/NvChad/wiki)
