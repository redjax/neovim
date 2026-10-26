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
