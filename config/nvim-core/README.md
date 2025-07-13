# Neovim Core

This is a special profile, where configurations I share across all my configurations live. This profile is symlinked like the others, but is not meant to be used directly (i.e. with `NVIM_APPNAME=nvim-core`). In fact, this configuration won't work as a profile. It only provides configurations for the selected Neovim profile.

Each other Neovim configuration can import from this package, i.e. with `require('nvim-core.config.platform')`. To enable this, you must add this near the top of your root `init.lua`, above any lines that would require Lua files from the `nvim-core` package:

```lua
vim.opt.runtimepath:append("~/.config/nvim-core")
```
