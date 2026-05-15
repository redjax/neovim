# Plugins <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Converting from LazyVim to Neovim 12 `vim.pack`](#converting-from-lazyvim-to-neovim-12-vimpack)
  - [Remove `lazy`‑specific fields](#remove-lazyspecific-fields)
  - [Put configuration into `setup`](#put-configuration-into-setup)
  - [Convert `keys` to `vim.keymap.set`](#convert-keys-to-vimkeymapset)
  - [Convert `event` / `init` / `ft` → `autocmd`](#convert-event--init--ft--autocmd)
  - [Handle `dependencies` manually](#handle-dependencies-manually)
  - [Preserve plugin‑local `opts` / `config` shapes](#preserve-pluginlocal-opts--config-shapes)
  - [Plugin Conversion Checklist](#plugin-conversion-checklist)

## Converting from LazyVim to Neovim 12 `vim.pack`

This is a practical guide for porting `lazy.nvim` (or `LazyVim`) plugin specs to your `nvim12`/`vim.pack` setup, where each plugin is a self‑contained `.lua` file and your `plugins/init.lua` driver does all the “magic”.

> [!NOTE]
> - Your loader is defined in [`nvim12/lua/plugins/init.lua`](../config/nvim12/lua/plugins/init.lua).
> - There’s also a handy example template in [`nvim12/lua/plugins/_template.lua`](../config/nvim12/lua/plugins/_template.lua) you can copy and tweak.

---

### Remove `lazy`‑specific fields

In `vim.pack` we don’t have `ft`, `event`, `keys`, etc. Those concepts are either handled by:

- explicit `autocmd` / `keymap` in `setup`, or
- the way your `init.lua` orchestrates loading and configuration.

**Drop these fields when converting from LazyVim**:

- `ft = { ... }`
- `event = { ... }`
- `cmd = { ... }`
- `keys = { ... }`
- `dependencies = { ... }`
- `dev = true`
- `cond = ...`
- `spec.config = function(...)` if you move that body into `setup`.

**What to keep/convert**:

- `src` -> keep the same (use the Github URL for the plugin):

  ```lua
  src = "https://github.com/owner/repo"
  ```

- `name` -> optional; keep or comment out.
- `version` -> optional; keep or comment out.
- `opts` -> move into `local opts = { ... }` inside `setup`.
- `config` -> move its body into `setup` (or call `require("plugin").setup(opts)` there).

A minimal plugin file looks like:

```lua
return {
  src = "https://github.com/owner/repo",
  -- name = "repo",
  -- version = "main",
  setup = function()
    -- local opts = { ... }  -- your old `opts` table
    -- require("plugin").setup(opts)
  end,
}
```

### Put configuration into `setup`

The [`plugins/init.lua`](../config/nvim12/lua/plugins/init.lua) loader in the `nvim12` config:

- Gathers all plugin specs via `list_plugins()` and `load_specs()`.
- Calls `vim.pack.add(pack_specs, { load = false })` to install the plugins.
- Configures the plugin (`configure_plugin(name)` -> `entry.setup(entry.spec)`).

That means you **only** need:

- `src`
- (optional) `name` and `version`
- `setup = function() ... end`

All that was in `opts` and `config` in `lazy` moves into `setup`:

```lua
setup = function()
  local opts = {
    -- ... your old `opts` table
  }
  require("plugin").setup(opts)
end
```

### Convert `keys` to `vim.keymap.set`

`vim.pack` does not auto‑load on keypress, so `keys` become normal `vim.keymap.set` calls inside `setup`.

Old `lazy` pattern:

```lua
keys = {
  { "<leader>f", function() require("plugin").do_something() end, mode = "n", desc = "Format buffer" },
}
```

New `setup` pattern:

```lua
setup = function()
  vim.keymap.set("n", "<leader>f", function()
    require("plugin").do_something()
  end, { desc = "Format buffer" })
end
```

Optional lazy‑load style (if you really want it):

```lua
vim.keymap.set("n", "<leader>f", function()
  vim.cmd("packadd plugin")
  require("plugin").do_something()
end, { desc = "Format buffer" })
```

You can see this pattern already in:

- [`dockerfile.lua`](../config/nvim12/lua/plugins/dockerfile.lua)
- [`docker-compose.lua`](../config/nvim12/lua/plugins/docker-compose.lua)

### Convert `event` / `init` / `ft` → `autocmd`

Instead of:

- `ft = { "dockerfile" }`
- `event = { "BufRead" }`
- `init = function() ... end`

You explicitly use `autocmd` and globals inside `setup`.

Example:

```lua
setup = function()
  -- init‑style globals
  vim.g.some_option = value

  -- event‑style / file‑name detection
  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "docker-compose*.yml",
    callback = function()
      vim.bo.filetype = "yaml.docker-compose"
    end,
  })

  -- filetype‑specific settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dockerfile",
    callback = function()
      vim.bo.shiftwidth = 2
      -- etc.
    end,
  })
end
```

You can see this pattern in:

- [`dockerfile.lua`](../config/nvim12/lua/plugins/dockerfile.lua)
- [`data-viewer.lua`](../config/nvim12/lua/plugins/data-viewer.lua)

### Handle `dependencies` manually

`vim.pack` has no `dependencies` field. You handle deps by:

- Making each plugin a separate file under `lua/plugins/*.lua`:
  - `nvim-bqf.lua`
  - `data-viewer.lua`
  - `plenary.lua`
  - `sqlite.lua`
- Ensuring they’re visible to `list_plugins()` so `load_specs()` and `vim.pack.add` add them to the `runtimepath`.

If plugin `A` does:

```lua
require("plenary.something")
```

then:

- `plenary.lua` exists and exports `"plenary"`
- your loader picked it up via `list_plugins()` → `registry` → `vim.pack.add`.

There’s no automatic transitive dependency resolution; you just keep your plugin list flat and explicit.

### Preserve plugin‑local `opts` / `config` shapes

Some plugins expect `opts = opts.merge(...)` or a specific table structure. You can mirror that directly.

If the plugin docs show:

```lua
opts = opts.merge({ ... }, defaults)
```

then:

```lua
setup = function()
  local defaults = require("plugin.defaults")
  local opts = require("plugin.opts").merge({
    -- your overrides
  }, defaults)
  require("plugin").setup(opts)
end
```

Or if it just wants a flat table:

```lua
setup = function()
  local opts = {
    -- your full config
  }
  require("plugin").setup(opts)
end
```

You can see this pattern in:

- [`fidget.lua`](../config/nvim12/lua/plugins/fidget.lua)
- [`conform.lua`](../config/nvim12/lua/plugins/conform.lua)

### Plugin Conversion Checklist

When you copy a `lazy`/`LazyVim` spec to the new spec:

1. Remove:
   - `ft`, `event`, `cmd`, `keys`, `dependencies`, `init`, `cond`, `dev`.
2. Move into `setup`:
   - `opts` -> `local opts = { ... }`.
   - `config` -> call `require("plugin").setup(opts)` there.
3. Translate:
   - `keys` -> `vim.keymap.set(...)` inside `setup`.
   - `event`/`init`/`ft` -> `autocmd` and globals.
4. Verify:
   - Is every `require("dep")` backed by a plugin file visible to `list_plugins()`?
   - Is `src` correct and `name` reasonable?
5. Shape:

```lua
return {
  src = "https://github.com/owner/repo",
  -- name = "repo",
  -- version = "main",
  setup = function()
    -- local opts = { ... }
    -- require("plugin").setup(opts)
    -- vim.keymap.set(...)
    -- vim.api.nvim_create_autocmd(...)
  end,
}
```
