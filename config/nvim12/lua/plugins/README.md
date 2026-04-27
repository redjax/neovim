# Vim.pack Plugins

This directory uses the new [`vim.pack`](https://neovim.io/doc/user/pack/) package manager built into Neovim. Each plugin lives in one file under `lua/plugins/` and returns a table consumed by `lua/plugins/init.lua`. Disabling a plugin is as easy as moving it into the `plugins/disabled/` directory.

Plugin files in `lua/plugins/` include native `vim.pack.Spec` fields and can also define an optional local `setup` callback for configuration.

## Minimal spec

```lua
return {
  src = "https://github.com/owner/repo",
}
```

## Native vim.pack fields

- `src` (required): git URL
- `name` (optional): plugin name override
- `version` (optional): branch/tag/commit/semver range

## Local setup callback

If a plugin needs configuration, keep it in the same plugin file via `setup`:

```lua
return {
  src = "https://github.com/owner/repo",
  setup = function(spec)
    require("plugin").setup({})
  end,
}
```

`setup` is handled by `lua/plugins/init.lua` after `packadd`. It is a local loader field, not a native `vim.pack.Spec` field.

## Notes

- Files in `plugins/disabled/` are ignored by the loader.
- Files whose names start with `_` are ignored (for templates/helpers).

## Starter copy template

Copy from `lua/plugins/_template.lua` and rename to a real plugin file (without leading underscore).
