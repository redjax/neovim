# Minimal

A single-file Lua config for Neovim, with minimal modifications/configurations.

My definition of minimal:

- Only options I've overridden.
  - In other configs, I might have a configuration set to its default as a reference that it's something I can change.
  - In this configuration, the only options that appear are overrides of a default.
- Only useful plugins.
  - I have a tendency to install a lot of plugins to test them out.
  - This config narrows the plugin selection to the ones I actually find indispensible.
  - It uses Neovim 0.12's new `vim.pack()` to install and configure plugins.
- Single file.
  - Instead of modularizing my Neovim configuration, this config uses a single `init.lua`, as is tradition.

## Local override

When using this configuration, you can place a file named `init.local.lua` in the same path as the configuration (default: `~/.config/nvim-minimal/`). Any plugins or options defined here will be sourced in addition to the `init.lua`, and will override options set in `init.lua`. This can be useful for overriding specific settings on specific machines, i.e. installing a different set of plugins on a work machine.
